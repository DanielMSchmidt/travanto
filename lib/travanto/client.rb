require 'typhoeus'
require 'json'

module Travanto
  class Client
    attr_accessor :username, :password
    include Typhoeus

    def initialize username, password
      @username = username
      @password = password
    end

    def occupancies object_id
      request = Typhoeus::Request.new(
        "http://api.travanto.de/json/belegzeiten/#{object_id}",
        method: :GET,
        userpwd: "#{username}:#{password}",
        headers: { Accept: "application/json", :"Content-type" => 'application/json' }
      )
      request.run
      response = request.response

      return ::Travanto::Response.new(response.success?, response.body)
    end

    def save_occupancies object_id, occupancies
      request = Typhoeus::Request.new(
        "http://api.travanto.de/json/belegzeiten/#{object_id}",
        method: :PUT,
        userpwd: "#{username}:#{password}",
        body: serialize(object_id, occupancies).to_json,
        headers: { Accept: "application/json", :"Content-type" => 'application/json' }
      )
      request.run
      response = request.response

      return ::Travanto::Response.new(response.success?, response.body)
    end

    def serialize object_id, occupancies
      return [{
        objekt: object_id,
        belegzeiten: occupancies.map { |occupancy|
          {
            anreise: occupancy.first,
            abreise: occupancy.last
          }
        }
      }]
    end
  end
end