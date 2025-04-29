# frozen_string_literal: true

module JabberAdmin
  # Handles a single communication with the API. An instance persists the
  # response when performed once. So you can get the response multiple times,
  # without repeating the request.
  class ApiCall
    attr_reader :command, :payload, :check_res_body

    # Setup a new API call instance with the given command and the given
    # request payload.
    #
    # @param command [String] the command to execute
    # @param check_res_body [Boolean] whenever to check the response body
    # @param payload the request payload, empty by default
    def initialize(command, check_res_body: true, **payload)
      @command = command
      @payload = payload
      @check_res_body = check_res_body
    end

    # The resulting URL of the API call. This URL is constructed with the
    # +JabberAdmin.configuration.url+ as base and the command name as the
    # suffix. The configuration is allowed to end with trailling slash, or not.
    #
    # @return [String] the API call URL
    def url
      "#{JabberAdmin.configuration.url.strip.chomp('/')}/#{@command}"
    end

    # This method compose the actual request, perfoms it and stores the
    # response to the instance.  Additional calls to this method will not
    # repeat the request, but will deliver the response directly.
    #
    # @return [RestClient::Response] the response of the API call
    def response
      @response ||= RestClient::Request.execute(
        method: :post,
        url: url,
        user: JabberAdmin.configuration.username,
        password: JabberAdmin.configuration.password,
        payload: payload.to_json
      )
    rescue RestClient::Exception => e
      @response = e.response
    end

    # Check if the response was successful. Otherwise raise exceptions with
    # +JabberAdmin::Exception+ as base type.
    #
    # @raise JabberAdmin::ApiError
    # @raise JabberAdmin::CommandError
    #
    # rubocop:disable Metrics/AbcSize -- because its the bundled check logic
    # rubocop:disable Metrics/MethodLength -- ditto
    def check_response
      # The REST API responds a 404 status code when the command is not known.
      if response.code == 404
        raise UnknownCommandError.new("Command '#{command}' is not known",
                                      response)
      end

      # In case we send commands with missing data or any other validation
      # issues, the REST API will respond with a 400 Bad Request status
      # code.
      raise CommandError.new('Invalid arguments for command', response) \
        if response.code == 400

      # Looks like the ejabberd REST API is returning 200 OK in case the
      # request was valid and permitted. But it does not indicate that the
      # request was successful handled. This is indicated on the response body
      # as a one (1) or a zero (0). (0 on success, 1 otherwise)
      raise RequestError.new('Response code was not 200', response) \
        unless response.code == 200

      # Stop the check, when we should not check the response body
      return unless check_res_body

      # The command was not successful, for some reason. Unfortunately we do
      # not get any further information here, which makes error debugging a
      # struggle.
      raise CommandError.new('Command was not successful', response) \
        unless response.body == '0'
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    # Just a simple DSL wrapper for the response method.
    #
    # @return [RestClient::Response] the API call response
    def perform
      response
    end

    # Just a simple DSL wrapper for the response method. But this variant
    # perfoms a response check which will raise excpetions when there are
    # issues.
    #
    # @raise JabberAdmin::ApiError
    # @raise JabberAdmin::CommandError
    # @return [RestClient::Response] the API call response
    def perform!
      check_response
      response
    end

    # A simple class level shortcut of the +perform+ method. This is just DSL
    # code which accepts the same arguments as the instance initialize method.
    # (+#new+)
    #
    # @param args [Array<Mixed>] the initializer arguments
    # @param kwargs [Hash{Symbol => Mixed}] the initializer arguments
    # @return [RestClient::Response] the API call response
    def self.perform(*args, **kwargs)
      new(*args, **kwargs).perform
    end

    # A simple class level shortcut of the +perform!+ method. This is just DSL
    # code which accepts the same arguments as the instance initialize method.
    # (+#new+)
    #
    # @param args [Array<Mixed>] the initializer arguments
    # @param kwargs [Hash{Symbol => Mixed}] the initializer arguments
    # @return [RestClient::Response] the API call response
    #
    # @raise JabberAdmin::ApiError
    # @raise JabberAdmin::CommandError
    def self.perform!(*args, **kwargs)
      new(*args, **kwargs).perform!
    end
  end
end
