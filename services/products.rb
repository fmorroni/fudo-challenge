# frozen_string_literal: true

require_relative '../models/product'

# :nodoc:
class ProductsService
  # @param store [MemoryStorage]
  def initialize(store)
    @store = store
  end

  # @param name [String]
  # @return [Product]
  def create_product(name)
    validate_name!(name)
    product = Product.new(name)
    @store.add_product(product)
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

class InvalidProductNameError < StandardError; end
class InvalidRange < StandardError; end
