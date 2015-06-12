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
    Gif.all.to_json
  end

  post "/tag" do
    if params[:id] && params[:tagname]
    t = GifBot.new
    taggy = t.tag_gif params[:id], params[:tagname]
    else
      status 400
    end
  end


  ## Optional Test requires this:

  # get "/tag" do
  # end

end

if $0 == __FILE__
  GifbotWeb.start!
end




# class ToDoWeb < Sinatra::Base
#   set :logging, true

#   post "/add" do
#     listicize = ToDoList.new
#     item = listicize.create_entry params[:list], params[:description], params[:due_date]
#     item.id.to_s
#   end

#   get "/list/:name" do
#     list = List.find_by_list_name! params[:name]
#     list.items.to_json
#   end
# end

# # $0 is $PROGRAM_NAME
# if $0 == __FILE__
#   ToDoWeb.start!
# end