require 'sinatra/base'
require 'mustache/sinatra'
require 'data_mapper'
require 'dm-serializer'
require 'json'
require 'pry'
require_relative 'db/bookmark'
require_relative 'db/tagging'
require_relative 'db/tag'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/bookmarks.db")
DataMapper.finalize.auto_upgrade!

class App < Sinatra::Base

  register Mustache::Sinatra

  set :root, File.dirname(__FILE__)

  Dir["#{root}/controllers/*.rb"].each {|file| require file}
  Dir["#{root}/views/*.rb"].each {|file| require file}
end
