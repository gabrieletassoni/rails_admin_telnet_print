class PrintItJob < ActiveJob::Base
  queue_as :default

  def perform header, printer_id
    # Do something later
    printer = Printer.find(printer_id.to_i)
    
    header.items_with_info.each do |item|
      begin
        s = TCPSocket.new(printer.ip, 9100)
        # Must create intepolation between item and template
        # Printer.template può essere anche 
        # una parola di comando epr chiedere lo stato della stampante, solo nel caso sia ok, 
        # Allora mando la stampa
        s.puts(printer.template)
        # Attende per la risposta (si mette in wait)
        while (response_text = s.gets)
          puts "#{response_text}"
          if response_text == "OK"
            # Solo nel caso sia ok, 
            # Allora mando la stampa
          end
        end
        s.close
        Rails.logger.debug "Stampa avviata con successo"
        # flash[:success] = "Stampa avviata con successo"
      rescue
        Rails.logger.debug "Impossibile connettersi alla stampante"
        # flash[:error] = "Impossibile connettersi alla stampante"
      end
    end
  end
end
