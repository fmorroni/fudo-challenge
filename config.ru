# frozen_string_literal: true

require_relative 'middleware/error_handler'
require_relative 'persistence/memory'
require_relative 'routes/products'

store = MemoryStorage.new

use ErrorHandler

map '/products' do
  run ProductsRoute.new(store)
end
