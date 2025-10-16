# frozen_string_literal: true

require 'jwt'

# :nodoc:
module JwtHelper
  SECRET_KEY = ENV['JWT_SECRET']
  ALGORITHM = 'HS256'
  ACCESS_TTL = 15 * 60 # 15 minutes
  REFRESH_TTL = 7 * 24 * 60 * 60 # 7 days

  # @param payload [Hash{Symbol,String => Object}]
  # @param type [:access, :refresh]
  # @return [String]
  def self.encode(payload, type: :access)
    ttl = type == :access ? ACCESS_TTL : REFRESH_TTL
    payload = payload.dup
    payload[:exp] = Time.now.to_i + ttl
    payload[:type] = type
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  # @param token [String]
  # @param type [:access, :refresh]
  # @return [Hash{String => Object}]
  def self.decode(token, type: :access)
    payload, _header = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
    raise InvalidTokenError, 'Invalid token type' unless payload['type'] == type.to_s

    payload
  rescue JWT::ExpiredSignature
    raise InvalidTokenError, 'Token expired'
  rescue JWT::DecodeError => e
    raise InvalidTokenError, "Invalid token: #{e.message}"
  end
end

class InvalidTokenError < StandardError; end
