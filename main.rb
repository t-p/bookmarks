require 'sinatra/base'
require 'haml'
require 'data_mapper'
require 'dm-serializer'
require 'json'
require 'pry'

Dir["#{File.dirname(__FILE__)}/db/*.rb"].each {|file| require file}

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/bookmarks.db")
DataMapper.finalize.auto_upgrade!

class App < Sinatra::Base
  set :views, 'public'
  set :haml,  :format => :html5
  set :root, File.dirname(__FILE__)

end

require_relative 'routes/init'
