class App < Sinatra::Base

  get "/" do
    redirect "/base"
  end
end
