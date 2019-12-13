# frozen_string_literal: true

module DadataApi
  #
  # API Request Class
  #
  class Request
    def self.find_by_tin(tin)
      new.find_by_tin(tin)
    end

    def self.find_by_something(query)
      new.find_by_something(query)
    end

    def initialize
      @api_key = DadataApi.configuration.api_key
      raise 'API base url not defined' unless @api_key
    end

    def find_by_tin(tin)
      find_request('/rs/findById/party', tin)
    end

    def find_by_something(query)
      find_request('/rs/suggest/party', query)
    end

    private

    def find_request(path, query)
      result = DadataApi::HTTP.call(path,
                                    :post,
                                    headers,
                                    query: query)

      data = JSON.parse(result, symbolize_names: query)
      data[:suggestions] unless data[:suggestions].empty?
    end

    def headers
      {
        accept: 'application/json',
        'content-type': 'application/json',
        'Authorization': "Token #{DadataApi.configuration.api_key}"
      }
    end
  end
end
