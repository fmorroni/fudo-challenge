# frozen_string_literal: true

require 'bcrypt'

require_relative '../lib/jwt_helper'
require_relative '../lib/service_errors'
require_relative '../models/user'

# :nodoc:
class UsersService
  # @param store [MemoryStorage]
  def initialize(store)
    @store = store
  end

  # @param username [String]
  # @param password [String]
  def create_user(username, password)
    validate_username!(username)
    validate_password!(password)
    user = User.new(username, BCrypt::Password.create(password).to_s)
    user = @store.create_user(user)
    raise AuthError, 'User already exists' unless user

    user
  end

  # @param username [String]
  # @param password [String]
  def login(username, password)
    user = @store.find_user(username)
    raise AuthError, 'User not found' unless user
    raise AuthError, 'Invalid password' unless BCrypt::Password.new(user.password) == password

    {
      access_token: JwtHelper.encode({ user: username })
    }
  end

  private

  # @param username [String]
  def validate_username!(username)
    return if username.match?(/\A\w*\z/)

    raise InvalidUsernameError, 'Username must contain only word characters'
  end

  # @param password [String]
  def validate_password!(password)
    return if password.match?(/\A(?=.*[A-Z])(?=.*[\W_]).{8,}\z/)

    raise InvalidPasswordError,
          'Password must be at least 8 characters long and contain an uppercase letter and a symbol'
  end
end
