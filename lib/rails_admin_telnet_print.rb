require 'thecore'
# require 'thecore_background_jobs'

# require 'models/print_job'
# require 'models/print_template'
# require 'models/printer'
#
# require 'jobs/application_job'
# require 'jobs/cancel_job'
# require 'jobs/print_it_job'
# require 'jobs/print_single_job'

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
          # visible only if authorized and if the object has a defined method
          authorized? && bindings[:object].respond_to?(:records_for_print)
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
              # Se non è una xhr, allora è proprio l'invio di stampa
              @printers = Printer.all # assigned_to(@abstract_model.model_name.downcase)
              if !params[:print_on].blank?
                # Visualizza la lista di stampanti diponibili
                # Effettivmaente invia la stampa e torna poi alla index del modello di partenza
                # @object è la commissione o sovracollo di partenza
                PrintItJob.perform_later @abstract_model.model_name, @object.id, params[:print_on] if params[:item_id].blank?
                # PrintSingleJob.perform_later @abstract_model.model_name, @object.id, params[:print_on], params[:item_id] if !params[:item_id].blank?
                # redirect_to action: :index
                unless params[:back_to].blank?
                  # http://localhost:3000/app/scan_item_barcode
                  redirect_to rails_admin.send(params[:back_to].to_sym, print_on: params[:print_on], chosen_item_id: @object.id)
                end
              elsif !params[:cancel].blank?
                CancelJob.perform_later params[:cancel]
              end
            end
          end
        end
      end
    end
  end
end
