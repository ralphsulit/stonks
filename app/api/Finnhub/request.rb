require 'rest-client'
require 'json'

module Finnhub 
    class Request
        BASE_URL = 'https://finnhub.io/api/v1/'
        API_KEY = 'c7ff3eaad3if3fodusgg'

        def self.call(http_method:, endpoint:)
            result = RestClient::Request.execute(
                method: http_method,
                url: "#{BASE_URL}#{endpoint}&token=#{API_KEY}",
                headers: {'Content-Type' => 'application/json'}
            )
            rescue => error
                p "#{error.message}"
            else
                JSON.parse(result)
        end
    end
end