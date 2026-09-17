# frozen_string_literal: true

module JabberAdmin
  # A JabberAdmin configuration definition. It is directly accessible via
  # +JabberAdmin.configuration+ or
  # +JabberAdmin.configure(&block(configuration))+ in a tapped variant.
  #
  # See the +JabberAdmin+ documentation for further details.
  class Configuration
    # The ejabberd REST API endpoint and the administrator credentials
    attr_accessor :username, :password, :url

    # The request timeout, either in seconds as a single number which caps
    # the whole request (connect, write and read together), or a hash with
    # per-operation limits (eg. +{ connect: 5, read: 30, write: 10 }+), or
    # +nil+ to disable the client timeout entirely. The value is passed to
    # the http gem as is, so a malformed hash raises an +ArgumentError+ on
    # the first request.
    #
    # See: https://github.com/httprb/http/wiki/Timeouts
    #
    # @return [Numeric, Hash{Symbol => Numeric}, nil] the request timeout
    attr_accessor :timeout

    # Setup a new configuration instance with the defaults. The endpoint and
    # the credentials have no defaults, the timeout defaults to 60 seconds.
    def initialize
      @timeout = 60
    end
  end
end
