# frozen_string_literal: true

# Require all commands from the commands subfolder
Dir["#{File.dirname(__FILE__)}/commands/**/*.rb"].each {|file| require file }

##
# Contains alle commands that are supported
module JabberAdmin
  module Commands; end
end
