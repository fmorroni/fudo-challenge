# frozen_string_literal: true

require 'json'

# :nodoc:
class Product
  attr_reader :id, :name

  # @param id [Integer]
  # @param name [String]
  def initialize(id, name)
    @id = id
    @name = name
  end

  def to_json(*args)
    { id: @id, name: @name }.to_json(*args)
  end
end
