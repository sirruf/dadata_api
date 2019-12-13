# frozen_string_literal: true

module DadataApi
  #
  # Organization Class
  #
  class Organization
    def self.where_tin(tin)
      @where_tin ||= DadataApi::Request.find_by_tin(tin).map do |params|
        create(params)
      end
    rescue
      nil
    end

    def self.search_by(query)
      @search_by ||= DadataApi::Request.find_by_something(query).map do |params|
        create(params)
      end
    rescue
      nil
    end

    def self.find_by_tin(tin)
      where_tin(tin)&.first
    end

    def self.find_by(query)
      search_by(query)&.first
    end

    def self.create(params)
      new(params)
    end

    def initialize(params)
      params_to_methods(params)
    end

    def name
      data[:value] unless data
    end

    def tin
      data[:inn] unless data
    end

    def ogrn
      data[:ogrn] unless data
    end

    private

    def params_to_methods(hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          instance_variable_set("@#{key}", params_to_methods(value))
          self.class.define_method(key) { instance_variable_get("@#{key}") }

        else
          instance_variable_set("@#{key}", value) unless value.nil?
        end
      end
    end
  end
end
