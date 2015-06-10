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
    post "add",
      url: "www.google.com",
      username: "Mark"
    assert_equal 200, last_response.status

    gif = Gif.find_by_url "www.google.com"
    assert gif
    assert_equal gif.id.to_s, last_response.body
  end

  def test_url_can_not_be_added_wihtout_a_name

  end

  def test_can_not_add_without_a_url

  end


end