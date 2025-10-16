# frozen_string_literal: true

require 'httparty'

require_relative '../lib/service_errors'
require_relative '../models/product'

# :nodoc:
class ProductsService
  EXTERNAL_API = ENV['EXTERNAL_API']

  # @param store [MemoryStorage]
  def initialize(store)
    @store = store
  end

  def sync_with_external_api
    return if @store.products_count.positive?

    response = HTTParty.get(EXTERNAL_API, headers: { 'Content-Type' => 'application/json' })
    products = response.parsed_response['data'].map { |p_hash| Product.new(p_hash['name'], p_hash['id']) }

    products.each do |p|
      @store.add_product_with_id(p)
    end
  rescue StandardError => e
    puts "Failed to syncronize products #{e.message}"
  end

  # @param name [String]
  def create_product(name)
    validate_name!(name)
    product = Product.new(name)
    Thread.new do
      @store.add_product(product)
    end
    nil
  end

  # @param offset [Integer]
  # @param count [Integer]
  # @return [Hash{products: Array<Product>, total: Integer}]
  def get_products(offset, limit)
    raise InvalidRange, 'Offset must be a positive integer' if offset.negative?
    raise InvalidRange, 'Limit must be between 0 and 100' if limit.negative? || limit > 100

    {
      products_and_total: @store.get_products(offset, limit),
      total: @store.products_count
    }
  end

  private

  # @param name [String]
  def validate_name!(name)
    return if name.match?(/\A[a-zA-Z]\w*\z/)

    raise InvalidProductNameError, 'Product name must start with an uppercase letter and contain only word characters'
  end
end
