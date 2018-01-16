# frozen_string_literal: true

module JabberAdmin
  # Error that will be raised when API call is not successful
  class ApiError < StandardError; end

  # Handles the communication with the API
  class ApiCall
    attr_reader :command, :payload

    def self.perform(command, payload = {})
      new(command, payload).perform
    end

    def initialize(command, payload)
      @command = command
      @payload = payload
    end

    def perform
      raise(ApiError, response.to_s) if response.code != 200

      response
    end

    private

    def response
      @res ||= RestClient::Request.execute(
        method: :post,
        url: url,
        user: JabberAdmin.configuration.admin,
        password: JabberAdmin.configuration.password,
        payload: payload.to_json
      )
    end

    def url
      "#{JabberAdmin.configuration.api_host}/api/#{@command}"
    end
  end
end
