# frozen_string_literal: true

require 'dotenv/load'

require_relative 'middleware/error_handler'
require_relative 'middleware/strip_trailing_slash'
require_relative 'persistence/memory'
require_relative 'routes/auth'
require_relative 'routes/products'
require_relative 'services/auth'
require_relative 'services/products'
require_relative 'services/users'

store = MemoryStorage.new

use ErrorHandler
use StripTrailingSlash

map '/auth' do
  run AuthRoute.new(UsersService.new(store))
end

map '/products' do
  # use Authenticate # maybe?
  run ProductsRoute.new(ProductsService.new(store), AuthService.new(store))
end
