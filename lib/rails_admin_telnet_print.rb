require "rails_admin_telnet_print/engine"

module RailsAdminTelnetPrint
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class TelnetPrint < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        
        register_instance_option :object_level do
          true
        end
        # This ensures the action only shows up for Users
        register_instance_option :visible? do
          authorized?
        end
        # We want the action on members, not the Users collection
        register_instance_option :member do
          true
        end

        register_instance_option :collection do
          false
        end
        
        register_instance_option :link_icon do
          'icon-print'
        end
        # You may or may not want pjax for your action
        register_instance_option :pjax? do
          false
        end
        
        register_instance_option :controller do
          Proc.new do
            # A cosa ho accesso?
            # bindings[:controller] is current controller instance
            # bindings[:abstract_model] is checked abstract model (except root actions)
            # bindings[:object] is checked instance object (member actions only)
            hostname = 'localhost'
            port = 9100
            begin
              s = TCPSocket.new(hostname, port)
              s.puts("Test")
              s.close
              flash[:success] = "Stampa avviata con successo"
            rescue
              flash[:error] = "Impossibile connettersi alla stampante"
            end
            redirect_to back_or_index
          end
        end
      end
    end
  end
end

