# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Restart ejabberd service gracefully.
    #
    # @see https://bit.ly/2G7YEwd
    class Restart
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      def self.call(callable)
        callable.call('restart')
      end
    end
  end
end
