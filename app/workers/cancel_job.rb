# require 'sidekiq-scheduler'

class ImportFromFtpWorker
  include Sidekiq::Worker

  # def perform(*args)

  # Legenda errori:
  # TIMEOUT: indirizzo della stampante non raggiungibile durante la stampa
  # UNREACHABLE: indirizzo della stampante non raggiungibile durante il controllo dello stato della stampante
  # HEAD UP: coperchio aperto
  # RIBBON OUT: ribbon terminato
  # PAPER OUT: carta terminata
  # PAUSE: stampante in pausa
  # OK: nessun errore

  def perform model_name, id, printer_id
    # Do something later
    printer = Printer.find(printer_id.to_i)
    send_to_printer printer.ip, "~ja"
  end

  def send_to_printer printer, text
    begin
      s = TCPSocket.new(printer, 9100)
      # Rails.logger.debug "TEMPERATURE: #{text}"
      s.puts(text)
      s.close
      @printed += 1
      return true
    rescue
      return false
    end
  end
end
