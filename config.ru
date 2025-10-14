# frozen_string_literal: true

require_relative 'routes/products'
require_relative 'persistence/memory'

store = MemoryStorage.new

map '/products' do
  run ProductsRoute.new(store)
end
