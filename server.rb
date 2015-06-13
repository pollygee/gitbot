require 'sinatra/base'
require './gifbot.rb'
require 'pry'

class GifbotWeb < Sinatra::Base
  set :logging, true

  post "/add" do 
  	if params[:url] && params[:username]
      list = GifBot.new
      gif = list.add_gif params[:url], params[:username]
      gif.id.to_s
    else
      status 400
    end
  end

  get "/show" do
    gif_number = Gif.all.count
    if gif_number > 0 
      g = GifBot.new
      g.random_gif.url
    else
      status 400
    end
  end

  get "/all" do
    g = GifBot.new
    if params[:tag_name]
      if params[:all]
        g.list_by_tag params[:tag_name]
      else

    else
      g.all_gifs.to_json
  end


  post "/tag" do
    if params[:id] && params[:tag_name]
    t = GifBot.new
    taggy = t.tag_gif params[:id], params[:tag_name]
    else
      status 400
    end
  end


end

if $0 == __FILE__
  GifbotWeb.start!
end
