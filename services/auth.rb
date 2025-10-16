# frozen_string_literal: true

require 'bcrypt'

require_relative '../lib/jwt_helper'
require_relative '../lib/service_errors'

# :nodoc:
class AuthService
  # @param store [MemoryStorage]
  def initialize(store)
    @store = store
  end

  # @param authorization [String]
  def verify_access_token(authorization)
    raise AuthError, 'Invalid token' unless authorization&.start_with?('Bearer ')

    token = authorization.split(' ').last
    JwtHelper.decode(token)
  end
end
