# frozen_string_literal: true

require 'json'
require 'rack'

require_relative '../lib/api_errors'
require_relative '../models/user'
require_relative '../services/users'

# :nodoc:
class AuthRoute
  # @param service [UsersService]
  def initialize(service)
    @service = service
    @routes = {
      '/register' => { 'POST' => method(:register) },
      '/login' => { 'POST' => method(:login) },
      '/refresh' => { 'POST' => method(:refresh) }
    }
  end

  def call(env)
    req = Rack::Request.new(env)

    route = @routes[req.path_info]

    raise ApiError.new(code: :not_found) unless route

    handler = route[req.request_method]
    raise ApiError.new(code: :method_not_allowed) unless handler

    handler.call(req)
  end

  private

  def route_match?(req, path, method)
    req.path_info == path && req.request_method == method
  end

  # @param req [Rack::Request]
  # @return [Array]
  def register(req)
    username = req.params['username']
    password = req.params['password']

    raise ApiError.new(code: :invalid_params), 'Missing username or password' unless username && password

    user = @service.create_user(username, password)
    Rack::Response.new(
      user.to_json,
      200,
      { 'Content-Type' => 'application/json' }
    ).finish
  end

  # @param req [Rack::Request]
  # @return [Array]
  def login(req)
    username = req.params['username']
    password = req.params['password']

    raise ApiError.new(code: :invalid_params), 'Missing username or password' unless username && password

    tokens = @service.login(username, password)
    Rack::Response.new(
      tokens.to_json,
      200,
      { 'Content-Type' => 'application/json' }
    ).finish
  end

  # @param req [Rack::Request]
  # @return [Array]
  def refresh(req); end
end
