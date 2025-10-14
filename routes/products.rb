# frozen_string_literal: true

require 'rack'
require 'json'
require_relative '../models/product'

# :nodoc:
class ProductsRoute
  # @param store [MemoryStorage]
  def initialize(store)
    @store = store
  end

  def call(env)
    req = Rack::Request.new(env)

    case req.request_method
    when 'POST'
      post(req)
    when 'GET'
      get(req)
    else
      Rack::Response.new('Method Not Allowed', 405, { 'Content-Type' => 'text/plain' }).finish
    end
  end

  # @param req [Rack::Request]
  # @return [Array]
  def post(req)
    product = @store.add_product(name: req.params['name'])
    pp product
    Rack::Response.new(
      product.to_json,
      200,
      { 'Content-Type' => 'application/json' }
    ).finish
  end

  # @param req [Rack::Request]
  # @return [Array]
  def get(req)
    offset = req.params['offset'].to_i
    limit  = req.params['limit']&.to_i || 10

    if limit > 100
      return Rack::Response.new(
        { error: 'limit cannot exceed 100' }.to_json, 400, { 'Content-Type' => 'application/json' }
      ).finish
    end

    @store.list_products(offset, limit)

    Rack::Response.new(
      {
        count: @store.products_count,
        offset: offset,
        limit: limit,
        data: @store.list_products(offset, limit)
      }.to_json,
      200,
      { 'Content-Type' => 'application/json' }
    ).finish
  end
end
