# frozen_string_literal: true

require_relative '../models/product'
require_relative '../models/user'

# :nodoc:
class MemoryStorage
  def initialize
    # @type [Integer]
    @next_id = 0
    # @type [Array<Product>]
    @products = []
    # @type [Hash{String => User}]
    @users = {}
  end

  # @param user [User]
  def create_user(user)
    return nil if @users[user.username]

    @users[user.username] = user
    user
  end

  # @param username [String]
  def find_user(username)
    @users[username]
  end

  # @param product [Product]
  # @return [Product]
  def add_product(product)
    sleep 5
    product.id = @next_id
    @next_id += 1
    @products << product
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
