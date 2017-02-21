require 'sinatra/base'
require 'sinatra/namespace'
require 'mongoid'
require 'pry'

class BookShelf < Sinatra::Base
  Mongoid.load! 'mongoid.config'

  [:models, :serializers, :routes, :lib].each do |dir|
    Dir[File.dirname(__FILE__) + "/#{dir}/*"].each { |f| require f }
  end

  # Register Helpers
  helpers ApplicationHelpers

  # Hooks and Default Routes
  before { content_type 'application/json' }
  get '/' do
    status 400
  end

  # Register Routes
  register Sinatra::BookRoutes
end
