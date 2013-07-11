module Travanto
  class Response
    attr_writer :success, :body

    def initialize success, body
      @success = success
      if success?
        begin
          @body = JSON.parse(body)
        rescue JSON::ParserError => e
          @body = body
          @success = false
        end
      else
        @body = body
      end
    end

    def success?
      return @success == true
    end

    def results
      return success? ? @body : []
    end
  end
end