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
          proc do
            I18n.locale = :it
            if request.xhr?
              # Cerco l'informazione se c'è un qualche job in stampa
              printer = Printer.find(params[:print_on])
              job = PrintJob.where(printer_id: printer.id).order(updated_at: :desc).first

              message = []
              if job.blank?
                message << "Nessun lavoro di stampa è mai stato inviato a questa stampante: <strong>#{printer.ip}</strong>"
              else
                number_of_prints = "#{job.printed}/#{job.total}"

                message << "Ultimo lavoro di stampa: <strong>#{printer.ip}:</strong>"
                message << (job.finished ? "<i>Stampa conclusa (#{number_of_prints})</i> " : "Stampa in corso #{number_of_prints}")
                message << (job.iserror ? job.description : "Nessun errore rilevato")
                message << "(#{I18n.l job.created_at})"
              end

              render html: message.join(" ").html_safe
            else
              @printers = Printer.assigned_to(@abstract_model.model_name.downcase)
              unless params[:print_on].blank?
                # Visualizza la lista di stampanti diponibili
                # Effettivmaente invia la stampa e torna poi alla index del modello di partenza
                # @object è la commissione o sovracollo di partenza
                PrintItJob.perform_later @abstract_model.model_name, @object.id, params[:print_on]
                # redirect_to action: :index
              end
            end
          end
        end
      end
    end
  end
end
