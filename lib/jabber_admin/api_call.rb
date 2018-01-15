# frozen_string_literal: true

module JabberAdmin
  # Error that will be raised when API call is not successful
  class ApiError < StandardError; end

  # Handles the communication with the API
  class ApiCall
    attr_reader :command, :payload

    include HTTParty
    base_uri JabberAdmin.configuration.api_host

    def self.perform(command, payload = {})
      new(command, payload).perform
    end

    def initialize(command, payload)
      @command = command
      @payload = payload
    end

    def perform
      raise(ApiError, response.to_s) unless response.success?

      response
    end

    private

    def response
      @res ||= self.class.post("/api/#{command}", body: body, basic_auth: auth)
    end

    def auth
      {
        username: JabberAdmin.configuration.admin,
        password: JabberAdmin.configuration.password
      }
    end

    def body
      payload.to_json
    end
  end
end
