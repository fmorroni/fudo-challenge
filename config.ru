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
users_service = UsersService.new(store)
products_service = ProductsService.new(store)
auth_service = AuthService.new(store)

products_service.sync_with_external_api

use ErrorHandler
use StripTrailingSlash

map '/auth' do
  run AuthRoute.new(users_service)
end

map '/products' do
  # use Authenticate # maybe?
  run ProductsRoute.new(products_service, auth_service)
end
