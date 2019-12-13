# frozen_string_literal: true

#
# DadataApi
#
module DadataApi
  #
  # Configuration
  #
  class Configuration
    attr_accessor :api_base_url, :api_key

    def initialize
      @api_base_url = 'https://suggestions.dadata.ru/suggestions/api/4_1'
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end
