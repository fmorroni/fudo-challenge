# frozen_string_literal: true

require_relative 'middleware/error_handler'
require_relative 'middleware/strip_trailing_slash'
require_relative 'persistence/memory'
require_relative 'routes/products'
require_relative 'services/products'

store = MemoryStorage.new

use ErrorHandler
use StripTrailingSlash

map '/products' do
  run ProductsRoute.new(ProductsService.new(store))
end
