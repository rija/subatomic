require 'atom/pub'
require 'sinatra/async'
require 'em-http'
require 'sync'


#use Rack::CommonLogger


run Sync.new

