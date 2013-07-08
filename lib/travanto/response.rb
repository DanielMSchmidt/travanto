module Travanto
  class Response
    attr_writer :success, :body

    def initialize success, body
      @success = success
      @body = JSON.parse(body) if success?
    end

    def success?
      return @success == true
    end

    def results
      return success? ? @body : []
    end
  end
end