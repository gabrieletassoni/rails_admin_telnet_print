# TheCoreActions.module_eval do
#   def telnet_print_action
#     telnet_print
#   end
# end

RailsAdmin.config do |config|
  config.actions do
    telnet_print
  end
end
