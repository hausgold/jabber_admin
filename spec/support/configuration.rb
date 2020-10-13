# frozen_string_literal: true

# Reset the gem configuration to its testing defaults.
def reset_configuration!
  JabberAdmin.configure do |jabber_conf|
    jabber_conf.url = 'http://jabber/api'
    jabber_conf.username = 'admin@ejabberd.local'
    jabber_conf.password = 'defaultpw'
  end
end

# Configure an alternative Jabber (ejabberd) server for VCR/testing.
def alternative_config!
  JabberAdmin.configure do |conf|
    conf.username = 'admin@jabber.local'
    conf.password = 'defaultpw'
    conf.url = 'http://jabber.local/api'
  end
end
