# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Set contents in a vCard.
    #
    # Examples:
    #
    #   JabberAdmin.set_vcard!(
    #     user: 'ac865680-9681-45da-8fee-8584053dde5b@jabber.local',
    #     'org.orgunit[]' => %w[Marketing Production],
    #     fn: 'Max Mustermann',
    #     'n.given': 'Max',
    #     'n.family' => 'Mustermann'
    #   )
    #   # => {"org.orgunit[]"=>["Marketing", "Production"],
    #   #     "n.family"=>"Mustermann",
    #   #     :fn=>"Max Mustermann",
    #   #     :"n.given"=>"Max"}
    #
    # @see https://bit.ly/2ZB9S6y
    # @see https://bit.ly/3lAIGzO
    # @see https://bit.ly/34MiviZ
    class SetVcard
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param args [Hash] the keys/values to set to the vCard
      #   (eg. +n.family+ for multiple levels)
      # @param user [String] user JID wo/ resource (eg. +tom@localhost+)
      # @param sym_args [Hash{Symbol => Mixed}] additional keys/values to
      #   set to the vCard
      # @return [Hash] the vCard details
      def self.call(callable, args = {}, user:, **sym_args)
        args = args.merge(sym_args)
        uid, host = user.split('@')

        set = proc do |key, val|
          parts = key.to_s.upcase.split('.')
          body = { name: parts.shift, content: val }
          meth = 'set_vcard'

          unless parts.empty?
            body[:subname] = parts.shift
            meth = 'set_vcard2'

            if body[:subname].end_with? '[]'
              meth += '_multi'
              body[:subname].delete_suffix!('[]')
              body[:contents] = body.delete(:content)
            end
          end

          callable.call(meth, user: uid, host: host, **body)
        end

        args.each { |key, val| set[key, val] }
        args
      end
    end
  end
end
