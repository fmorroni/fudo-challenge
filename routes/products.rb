# frozen_string_literal: true

require 'json'
require 'rack'

require_relative '../lib/api_errors'
require_relative '../models/product'

# :nodoc:
class ProductsRoute
  # @param store [MemoryStorage]
  def initialize(store)
    @store = store
  end

  def call(env)
    req = Rack::Request.new(env)

    raise ApiError.new(code: :not_found) if req.path_info != '' && req.path_info != '/'

    case req.request_method
    when 'POST'
      add_product(req)
    when 'GET'
      get_products(req)
    else
      raise ApiError.new(code: :method_not_allowed)
    end
  end

  # @param req [Rack::Request]
  # @return [Array]
  def add_product(req)
    raise ApiError.new(code: :invalid_params), 'Missing product name' unless req.params['name']

    product = @store.add_product(name: req.params['name'])
    Rack::Response.new(
      product.to_json,
      200,
      { 'Content-Type' => 'application/json' }
    ).finish
  end

  # @param req [Rack::Request]
  # @return [Array]
  def get_products(req)
    offset = req.params['offset'].to_i
    limit = req.params['limit']&.to_i || 10

    raise ApiError.new(code: :invalid_limit) if limit > 100

    products = @store.get_products(offset, limit)

    Rack::Response.new(
      { count: @store.products_count, offset:, limit:, data: products }.to_json,
      200,
      { 'Content-Type' => 'application/json' }
    ).finish
  end
end
