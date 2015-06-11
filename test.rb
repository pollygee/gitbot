require 'minitest/autorun'
require 'rack/test'

ENV["TEST"] = ENV["RACK_ENV"] = "test"

require './db/setup'
require './lib/all'

require './server'

require 'pry'

class GifBotTest < Minitest::Test
  include Rack::Test::Methods
  def app
    GifbotWeb
  end

  def setup
    Gif.delete_all
    Tag.delete_all
    GifTag.delete_all
  end

  def test_users_can_add_gifs
    post "/add",
      url: "www.google.com",
      username: "Mark"
    assert_equal 200, last_response.status

    gif = Gif.find_by_url "www.google.com"
    assert gif
    assert_equal gif.id.to_s, last_response.body
  end


  def test_url_can_not_be_added_wihtout_a_username
    post "/add",
      url: "www.google.com"
    assert_equal 400, last_response.status
    assert_equal 0, Gif.count
  end


  def test_get_1_random_gif
    post "/add",
      url: "www.google.com",
      username: "Mark"
    post "/add",
      url: "www.nba.com",
      username: "Mark"
    post "/add",
      url: "www.chess.com",
      username: "Mark"
    post "/add",
      url: "rubyruby.com",
      username: "Polly"
    post "/add",
      url: "sharkescape.com",
      username: "Jeff"
    get "/show"
    urls = ["www.google.com", "www.nba.com", "chess.com", "rubyruby.com", "sharkescape.com"]
    assert_equal 200, last_response.status
    assert_equal 5, Gif.count
    assert (urls.include? last_response.body)
  end

  # def test_seen_count
  #   assert_equal 0, has_been_seen
  #   post "/add"
  #     url:"www.google.com"
  #   get "/show"
  #   assert_equal 1, has_been_seen
  # end

end