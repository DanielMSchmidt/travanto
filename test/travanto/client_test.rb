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

  def test_saves_occupancies_to_remote_endpoint
    response_body = {
      inserted: "1",
      deleted: "2"
    }
    response = Typhoeus::Response.new(code: 200, body: JSON.dump(response_body))
    Typhoeus.stub(/travanto/).and_return(response)

    c = ::Travanto::Client.new "user1234", "testtest"
    c.save_occupancies "1000", [["2013-01-01", "2013-05-01"]]

    assert response.success?
  end

  def test_generates_proper_serialization
    serialized = {
      objekt: "1000",
      belegzeiten: [
        {
          anreise: "2013-01-01",
          abreise: "2013-05-01"
        }
      ]
    }

    c = ::Travanto::Client.new "user1234", "testtest"
    assert_equal serialized, c.serialize("1000", [["2013-01-01", "2013-05-01"]])
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