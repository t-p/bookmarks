require "#{File.dirname(__FILE__)}/spec_helper"

describe "Bookmark application" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "returns a list of bookmarks" do
    get "/bookmarks"
    last_response.should be_ok
    bookmarks = JSON.parse(last_response.body)
    bookmarks.should be_instance_of(Array)
  end

  it "creates a new bookmark" do
    get "/bookmarks"
    bookmarks = JSON.parse(last_response.body)
    last_size = bookmarks.size

    post "/bookmarks",
      {:url => "http://www.test.com", :title => "Test"}
    last_response.status.should == 201
    last_response.body.should match(/\/bookmarks\/\d+/)

    get "/bookmarks"
    bookmarks = JSON.parse(last_response.body)
    expect(bookmarks.size).to eq(last_size + 1)
  end

  it "sends an error code for an invalid create request" do
    post "/bookmarks", {:url => "test", :title => "Test"}
    last_response.status.should == 400
  end

  it "updates a bookmark" do
    post "/bookmarks",
      {:url => "http://www.test.com", :title => "Test"}
    bookmark_uri = last_response.body
    id = bookmark_uri.split("/").last

    put "/bookmarks/#{id}",
      {:url => "http://www.test.com", :title => "Success"}
    last_response.status.should == 204

    get "/bookmarks/#{id}"
    retrieved_bookmark = JSON.parse(last_response.body)
    expect(retrieved_bookmark["title"]).to eq("Success")
  end

  it "sends an error code for an invalid update request" do
    post "/bookmarks",
      {:url => "http://www.test.com", :title => "Test"}
    bookmark_uri = last_response.body
    id = bookmark_uri.split("/").last

    put "/bookmarks/#{id}", {:url => "Invalid"}
    last_response.status.should == 400
  end

  it "deletes a bookmark" do
    get "/bookmarks"
    bookmarks = JSON.parse(last_response.body)
    last_size = bookmarks.size

    post "/bookmarks",
      {:url => "http://www.test.com", :title => "Test"}
    bookmark_uri = last_response.body
    id = bookmark_uri.split("/").last

    get "/bookmarks"
    bookmarks = JSON.parse(last_response.body)
    expect(bookmarks.size).to eq(last_size + 1)

    delete "/bookmarks/#{id}"
    last_response.status.should == 200
    last_response.body.should be_empty

    get "/bookmarks"
    bookmarks = JSON.parse(last_response.body)
    expect(bookmarks.size).to eq(last_size)
  end
end
