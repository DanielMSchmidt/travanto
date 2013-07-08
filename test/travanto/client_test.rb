require 'test_helper'

class ClientTest < MiniTest::Unit::TestCase
  def test_takes_two_arguments
    c = ::Travanto::Client.new "user1234", "nopass"
    assert_equal "user1234", c.username
    assert_equal "nopass", c.password
  end

  def test_requests_occupancies_from_remote_endpoint
    response_body = [{
      "objekt" => 102565,
      "belegzeiten"=>[
        {
          "anreise"=>"2013-07-01",
          "abreise"=>"2013-07-10",
          "gast"=>"Max Mustermann",
          "personen"=>"6",
          "kommentar"=>"Hat schon bezahlt"
        }]
      }
    ]
    response = Typhoeus::Response.new(code: 200, body: JSON.dump(response_body))
    Typhoeus.stub("http://api.travanto.de/json/belegzeiten/102565").and_return(response)

    c = ::Travanto::Client.new "user100267", "testcode"
    results = c.occupancies "102565"

    assert_equal response_body, results
  end
end