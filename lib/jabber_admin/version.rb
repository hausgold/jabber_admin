# frozen_string_literal: true

# The gem module.
module JabberAdmin
  # The version constant of the gem. Increase this value
  # in case of a gem release.
  VERSION = '1.0.5'

  class << self
    # Returns the version of gem as a string.
    #
    # @return [String] the gem version as string
    def version
      VERSION
    end

    # Returns the version of the gem as a +Gem::Version+.
    #
    # @return [Gem::Version] the gem version as object
    def gem_version
      Gem::Version.new VERSION
    end
  end
end
