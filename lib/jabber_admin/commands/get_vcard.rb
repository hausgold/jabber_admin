# frozen_string_literal: true

module JabberAdmin
  module Commands
    # Get content from a vCard.
    #
    # Examples:
    #
    #   JabberAdmin.get_vcard!(
    #     :fn, 'n.given', 'org.orgunit[]', 'u.known[]',
    #     user: 'ac865680-9681-45da-8fee-8584053dde5b@jabber.local'
    #   )
    #   # => {:fn=>"Max Mustermann",
    #   #     "n.given"=>"Max",
    #   #     "org.orgunit"=>["Marketing", "Production"],
    #   #     "u.known"=>nil}
    #
    # **Heads up!** ejabberd version 18.01 has a bug at the +get_vcard2_multi+
    # command, which just returns the first element of possible multiple
    # values. (in an array)
    #
    # @see https://bit.ly/2SLkEWi
    # @see https://bit.ly/34T71dm
    # @see https://bit.ly/3nKqiGL
    class GetVcard
      # Pass the correct data to the given callable.
      #
      # @param callable [Proc, #call] the callable to call
      # @param keys [Array<String, Symbol>, String, Symbol] name of the
      #   vCard field (+n.family+ for multiple levels)
      # @param user [String] user JID wo/ resource (eg. +tom@localhost+)
      # @return [Hash] the vCard details
      #
      # rubocop:disable Metrics/MethodLength because the ejabberd REST API is
      #   hard to use in complex scenarios, so we have to work around it
      # rubocop:disable Metrics/AbcSize dito
      # rubocop:disable Metrics/CyclomaticComplexity dito
      # rubocop:disable Metrics/PerceivedComplexity dito
      def self.call(callable, *keys, user:)
        uid, host = user.split('@')
        val = proc do |key|
          parts = key.to_s.upcase.split('.')
          args = { name: parts.shift }
          meth = 'get_vcard'

          unless parts.empty?
            args[:subname] = parts.shift
            meth = 'get_vcard2'

            if args[:subname].end_with? '[]'
              meth += '_multi'
              args[:subname].delete_suffix!('[]')
            end
          end

          res = JSON.parse(callable.call(meth, check_res_body: false,
                                               user: uid,
                                               host: host,
                                               **args).body)

          res.is_a?(Hash) ? res['content'] : res
        rescue JabberAdmin::CommandError => e
          # When ejabberd tells us there was no value, it does this the hard way
          next if e.response.body.include? 'error_no_value_found_in_vcard'

          raise e
        end

        # When just one key is requested, we return the value directly
        return val[keys.first] if keys.count == 1

        # When multiple keys are requested, we assemble a hash
        keys.map do |key|
          res_key = key.is_a?(String) ? key.delete_suffix('[]') : key
          [res_key, val[key]]
        end.to_h
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity
    end
  end
end
