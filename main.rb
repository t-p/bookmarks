require 'sinatra'
require 'data_mapper'
require 'dm-serializer'
require "sinatra/mustache"
require 'pry'
require_relative 'db/bookmark'
require_relative 'db/tagging'
require_relative 'db/tag'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/bookmarks.db")
DataMapper.finalize.auto_upgrade!

before "/bookmarks/:id" do |id|
  @bookmark = Bookmark.get(id)

  if !@bookmark
    halt 404, "bookmark #{id} not found"
  end
end

with_tagList = {:methods => [:tagList]}

get "/bookmarks/:id" do
  content_type :json
  @bookmark.to_json with_tagList
end

put "/bookmarks/:id" do
  input = params.slice "url", "title"

  if @bookmark.update input
    204 # No Content
  else
    400 # Bad Request
  end
end

get "/bookmarks/*" do
  bookmarks = Bookmark.all
  tags = params[:splat].first.split "/"

  tags.each do |tag|
    bookmarks = bookmarks.all({:taggings => {:tag => {:label => tag}}})
  end

  bookmarks.to_json with_tagList
end

get "/bookmarks" do
  content_type :json
  get_all_bookmarks.to_json with_tagList
end

post "/bookmarks" do
  input = params.slice "url", "title"
  bookmark = Bookmark.create input
  if bookmark.save
    add_tags(bookmark)
    # Created
    [201, "/bookmarks/#{bookmark['id']}"]
  else
    400 # Bad Request
  end
end

delete "/bookmarks/:id" do
  @bookmark.destroy
  200 # OK
end

helpers do
  def add_tags(bookmark)
    labels = (params["tagsAsString"] || "").split(",").map(&:strip)

    # more code to come
    existing_labels = []
    bookmark.taggings.each do |tagging|
      if labels.include? tagging.tag.label
        existing_labels.push tagging.tag.label
      else
        tagging.destroy
      end
    end

    (labels - existing_labels).each do |label|
      tag = {:label => label}
      existing = Tag.first tag
      if !existing
        existing = Tag.create tag
      end
      Tagging.create :tag => existing, :bookmark => bookmark
    end
  end
end

def get_all_bookmarks
  Bookmark.all(:order => :title)
end

class Hash
  def slice(*whitelist)
    whitelist.inject({}) {|result, key| result.merge(key => self[key])}
  end
end
