# frozen_string_literal: true

require 'json'
require 'rack'

# :nodoc:
class ApiError < StandardError
  attr_reader :code, :http_status

  CODES = {
    invalid_limit: { http_status: 400, message: 'Limit cannot exceed 100' },
    invalid_params: { http_status: 400, message: 'Missing or invalid parameters' },
    unauthorized: { http_status: 401, message: 'Unauthorized' },
    not_found: { http_status: 404, message: 'Resource not found' },
    method_not_allowed: { http_status: 405, message: 'Method not allowed' },
    internal_error: { http_status: 500, message: 'Internal server error' }
  }.freeze

  def initialize(message = nil, code:)
    raise ArgumentError, "Invalid ApiError code: #{code.inspect}" unless CODES.key?(code)

    @code = code
    @http_status = CODES[code][:http_status]

    super(message || CODES[code][:message])
  end

  def to_json(*)
    { error: { code: @code, message: message } }.to_json
  end

  def to_response
    Rack::Response.new(
      to_json,
      @http_status,
      { 'Content-Type' => 'application/json' }
    ).finish
  end
end
