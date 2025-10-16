# frozen_string_literal: true

require 'json'

# :nodoc:
class Product
  attr_accessor :id, :name

  # @param name [String]
  def initialize(name, id = nil)
    # @type [Integer]
    @id = id
    @name = name
  end

  def to_json(*args)
    { id: @id, name: @name }.to_json(*args)
  end
end
