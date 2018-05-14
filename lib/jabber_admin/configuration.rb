# frozen_string_literal: true

module JabberAdmin
  # A JabberAdmin configuration definition. It is directly accessible via
  # +JabberAdmin.configuration+ or
  # +JabberAdmin.configure(&block(configuration))+ in a tapped variant.
  #
  # See the +JabberAdmin+ documentation for further details.
  class Configuration
    attr_accessor :username, :password, :url
  end
end
