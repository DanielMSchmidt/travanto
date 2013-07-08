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
    Typhoeus.stub(/travanto/).and_return(response)

    c = ::Travanto::Client.new "user1234", "testtest"
    results = c.occupancies "1000"

    assert response.success?
    assert_equal response_body, results.results
  end

  def test_returns_empty_resultset_on_remote_errors
    response = Typhoeus::Response.new(code: 401, body: "Nicht authentifiziert.")
    Typhoeus.stub(/travanto/).and_return(response)

    c = ::Travanto::Client.new "user1234", "testtest"
    response = c.occupancies "1000"

    assert !response.success?
    assert_equal [], response.results
  end
end