# Fix pluralization of commands
ActiveSupport::Inflector.inflections do |inflect|
    inflect.irregular 'create_room_with_opts', 'create_room_with_opts'
end

