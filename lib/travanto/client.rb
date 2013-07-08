require 'typhoeus'

module Travanto
  class Client
    attr_accessor :username, :password
    include Typhoeus

    def initialize username, password
      @username = username
      @password = password
    end

    remote_defaults :on_success => lambda {|response| JSON.parse(response.body)},
                    :on_failure => lambda {|response| puts "error code: #{response.code}"},
                    :base_uri   => "http://api.travanto.de"

    define_remote_method :belegzeiten, :path => '/json/belegzeiten/:object_id'
  end
end