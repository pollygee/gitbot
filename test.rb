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
    #Should we delete User class as well? 
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
    urls = ["www.google.com", "www.nba.com", "www.chess.com", "rubyruby.com", "sharkescape.com"]
    assert_equal 200, last_response.status
    assert_equal 5, Gif.count
    assert (urls.include? last_response.body)
  end


  def test_seen_count_works
    assert_equal 0, Gif.where(seen_count:1).count
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
    assert_equal 1, Gif.where(seen_count:1).count
  end


  def test_get_all_gif_urls
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
    get "/all"
    urls = ["www.google.com", "www.nba.com", "www.chess.com", "rubyruby.com", "sharkescape.com"]
    assert_equal 5, JSON.parse(last_response.body).length
    assert_equal 200, last_response.status
  end

  def test_gifs_are_tagged
    post "/add",
      url: "www.google.com",
      username: "Mark"
    gif = Gif.find_by_url "www.google.com"
    post "/tag",
      id: gif.id,
      tag_name: "cookie"

    giftag = GifTag.find_by gif_id: gif.id
    assert giftag
    assert_equal 200, last_response.status
  end

  def test_limit_lists
    post "/add",
      url: "www.google.com",
      username: "Mark"
    post "/add",
      url: "www.bing.com",
      username: "Bob"
    post "/add",
      url: "www.ask.com",
      username: "Joe"
    gif = Gif.find_by_url "www.google.com"
    gif2 = Gif.find_by_url "www.bing.com"
    gif3 = Gif.find_by_url "www.ask.com"
    post "/tag",
      id: gif.id,
      tag_name: "search"
    post "/tag",
      id: gif2.id,
      tag_name: "search"
    post "/tag",
      id: gif3.id,
      tag_name: "not_search"
    get "/all",
      tag_name: "search"

    assert_equal 200, last_response.status
    response =JSON.parse(last_response.body)
    assert_equal true, last_response.body.include?("www.google.com")
    assert_equal true, last_response.body.include?("www.bing.com")
  end

  def get_single_random_gif_with_tag
    post "/add",
      url: "www.google.com",
      username: "Mark"
    post "/add",
      url: "www.bing.com",
      username: "Bob"
    post "/add",
      url: "www.ask.com",
      username: "Joe"
    gif = Gif.find_by_url "www.google.com"
    gif2 = Gif.find_by_url "www.bing.com"
    gif3 = Gif.find_by_url "www.ask.com"
    post "/tag",
      id: gif.id,
      tag_name: "search"
    post "/tag",
      id: gif2.id,
      tag_name: "search"
    post "/tag",
      id: gif3.id,
      tag_name: "not_search"
    get "/gif",
      tag_name: "search"

      assert_equal 200, last_response.status
      response =JSON.parse(last_response.body)
      #possible_answers = ["www.google.com", "www.bing.com"]
      assert_equal true, response.include?("www.google.com")  || response.include?("www.bing.com")
  end

end







