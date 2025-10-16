# frozen_string_literal: true

require 'json'
require 'rack'

require_relative '../lib/api_errors'
require_relative '../models/product'
require_relative '../services/auth'
require_relative '../services/products'

# :nodoc:
class ProductsRoute
  # @param products_service [ProductsService]
  # @param auth_service [AuthService]
  def initialize(products_service, auth_service)
    @products_service = products_service
    @auth_service = auth_service
  end

  def call(env)
    req = Rack::Request.new(env)

    raise ApiError.new(code: :not_found) if req.path_info != ''

    case req.request_method
    when 'POST'
      add_product(req)
    when 'GET'
      get_products(req)
    else
      raise ApiError.new(code: :method_not_allowed)
    end
  end

  private

  # @param req [Rack::Request]
  # @return [Array]
  def add_product(req)
    @auth_service.verify_access_token(req.get_header('HTTP_AUTHORIZATION'))
    name = req.params['name']
    raise ApiError.new(code: :invalid_params), 'Missing product name' unless name

    @products_service.create_product(name)
    Rack::Response.new(
      {
        message: 'The product is being created'
      }.to_json,
      202,
      { 'Content-Type' => 'application/json' }
    ).finish
  end

  # @param req [Rack::Request]
  # @return [Array]
  def get_products(req)
    @auth_service.verify_access_token(req.get_header('HTTP_AUTHORIZATION'))
    offset = req.params['offset'].to_i
    limit = req.params['limit']&.to_i || 10

    products_and_total = @products_service.get_products(offset, limit)

    Rack::Response.new(
      { offset:, limit:, **products_and_total }.to_json,
      200,
      { 'Content-Type' => 'application/json' }
    ).finish
  end
end
