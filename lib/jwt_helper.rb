# frozen_string_literal: true

require 'jwt'

# :nodoc:
module JwtHelper
  SECRET_KEY = ENV['JWT_SECRET']
  ALGORITHM = 'HS256'
  ACCESS_TTL = 15 * 60 # 15 minutes

  # @param payload [Hash{Symbol,String => Object}]
  # @return [String]
  def self.encode(payload)
    ttl = ACCESS_TTL
    payload = payload.dup
    payload[:exp] = Time.now.to_i + ttl
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  # @param token [String]
  # @return [Hash{String => Object}]
  def self.decode(token)
    payload, _header = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
    payload
  rescue JWT::ExpiredSignature
    raise InvalidTokenError, 'Token expired'
  rescue JWT::DecodeError => e
    raise InvalidTokenError, "Invalid token: #{e.message}"
  end
end

class InvalidTokenError < StandardError; end
