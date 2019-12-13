# frozen_string_literal: true

require 'net/http'
require 'net/https'
require 'json'

module DadataApi
  #
  # DadataApi HTTP calls
  #
  class HTTP
    def initialize(path, method, headers = {}, params = {})
      @method = method
      @path = path
      @params = params
      @headers = headers
    end

    def self.call(path, method, headers = {}, params = {})
      api = new(path, method, headers, params)
      api.call
    end

    def call
      request = @method == :post ? post : get
      @headers.each do |k, v|
        request[k] = v
      end
      response = http.request request
      response.body
    end

    private

    def post
      req = Net::HTTP::Post.new "#{uri.path}#{@path}"
      req.body = @params.to_json

      req
    end

    def get
      path = @params.present? ? "#{@path}?#{form_data}" : @path
      Net::HTTP::Get.new path
    end

    def form_data
      URI.encode_www_form(@params)
    end

    def http
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.instance_of? URI::HTTPS
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.set_debug_output($stdout) if ENV['DADATA_DEBUG_ENABLED']

      http
    end

    def uri
      @uri ||= URI.parse(DadataApi.configuration.api_base_url)
      raise StandardError "API base url not defined" unless @uri

      @uri
    end
  end
end
