# frozen_string_literal: true

module JabberAdmin
  # Contains all predefined commands that are supported.
  module Commands; end
end

# Require all commands from the commands subfolder
Dir[Pathname.new(__dir__).join('commands', '**', '*.rb')].sort.each do |file|
  require file
end
