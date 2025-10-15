# frozen_string_literal: true

# :nodoc:
class MemoryStorage
  def initialize
    # @type [Integer]
    @next_id = 0
    # @type [Array<Product>]
    @products = []
  end

  # @param name [String]
  # @return [Product]
  def add_product(name)
    product = Product.new(@next_id, name)
    @products << product
    @next_id += 1
    product
  end

  # @param offset [Integer]
  # @param count [Integer]
  # @return [Array<Product>]
  def get_products(offset, limit)
    @products[offset, limit] || []
  end

  # @return [Integer]
  def products_count
    @products.length
  end
end
