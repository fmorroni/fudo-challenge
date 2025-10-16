# frozen_string_literal: true

require 'json'

# :nodoc:
class User
  attr_reader :username, :password

  # @param username [String]
  # @param password [String]
  def initialize(username, password)
    @username = username
    @password = password
  end

  def to_json(*args)
    { username: @username }.to_json(*args)
  end
end
