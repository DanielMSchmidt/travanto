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
        method: :get,
        userpwd: "#{username}:#{password}"
      )
      request.run
      response = request.response

      return ::Travanto::Response.new(response.success?, response.body)
    end
  end
end