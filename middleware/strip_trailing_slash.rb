# frozen_string_literal: true

# Strip trailing slash from path info
class StripTrailingSlash
  def initialize(app)
    @app = app
  end

  def call(env)
    env['PATH_INFO'] = env['PATH_INFO'].chomp('/') unless env['PATH_INFO'] == '/'
    @app.call(env)
  end
end
