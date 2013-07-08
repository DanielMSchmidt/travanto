require 'test_helper'

class ClientTest < MiniTest::Unit::TestCase
  def test_takes_two_arguments
    c = ::Travanto::Client.new "user1234", "nopass"
    assert_equal "user1234", c.username
    assert_equal "nopass", c.password
  end
end