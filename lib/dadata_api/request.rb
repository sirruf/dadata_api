module DadataApi
  class Request
    def self.find_by_tin(tin)
      api_key = DadataApi.configuration.api_key
      raise 'API base url not defined' unless api_key

      new.find_by_tin(tin)
    end

    def find_by_tin(tin)
      result = DadataApi::HTTP.call('/rs/findById/party',
                                    :post,
                                    headers,
                                    { query: tin }
      )

      result
    end

    #private

    def headers
      {
          accept: 'application/json',
          'content-type': 'application/json',
          'Authorization': "Token #{DadataApi.configuration.api_key}"
      }
    end
  end
end