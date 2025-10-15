# frozen_string_literal: true

require 'rack'

require_relative '../lib/api_errors'

# :nodoc:
class ErrorHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ApiError => e
    e.to_response
  end
end
