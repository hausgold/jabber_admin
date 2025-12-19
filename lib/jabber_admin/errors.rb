# frozen_string_literal: true

module JabberAdmin
  # The base exception which all other exceptions inherit. In case you want to
  # use our error handling with the bang variants, you can rescue all
  # exceptions like this:
  #
  #   begin
  #     JabberAdmin.COMMAND!
  #   rescue JabberAdmin::Error => err
  #     # Do your error handling here
  #   end
  class Error < StandardError
    attr_accessor :response

    # Create a new exception.
    #
    # @param msg [String] the exception message
    # @param response [RestClient::Response] the response when available
    def initialize(msg, response = nil)
      @response = response
      msg += " => #{response.body}" if response&.body
      super(msg)
    end
  end

  # This exception is raised when the request was denied due to permission
  # issues or a general unavailability of the command on the REST API. This
  # simply means the response code from ejabberd was not 200 OK.
  class RequestError < Error; end

  # This exception is raised when the response from the ejabberd REST API
  # indicated that the status of the command was not successful. In this case
  # the response body includes a one (1). In case everything was fine, it
  # includes a zero (0).
  class CommandError < Error; end

  # This exception is raised when we send an unknown command to the REST API.
  # It will respond with a 404 status code in this case.
  class UnknownCommandError < Error; end
end
