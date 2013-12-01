require 'sinatra'
require 'data_mapper'
require 'dm-serializer'
require 'pry'
require_relative 'bookmark'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/bookmarks.db")
DataMapper.finalize.auto_upgrade!

def get_all_bookmarks
  Bookmark.all(:order => :title)
end

before "/bookmarks/:id" do |id|
  @bookmark = Bookmark.get(id)

  if !@bookmark
    halt 404, "bookmark #{id} not found"
  end
end

get "/bookmarks" do
  content_type :json
  get_all_bookmarks.to_json
end

post "/bookmarks" do
  input = params.slice "url", "title"
  bookmark = Bookmark.create input
  if bookmark.save
    # Created
    [201, "/bookmarks/#{bookmark['id']}"]
  else
    400 # Bad Request
  end
end

get "/bookmarks/:id" do |id|
  content_type :json
  @bookmark.to_json
end

put "/bookmarks/:id" do |id|
  input = params.slice "url", "title"

  if @bookmark.update input
    204 # No Content
  else
    400 # Bad Request
  end
end

delete "/bookmarks/:id" do |id|
  @bookmark.destroy
  200 # OK
end

class Hash
  def slice(*whitelist)
    whitelist.inject({}) {|result, key| result.merge(key => self[key])}
  end
end
