class PrintItJob < ActiveJob::Base
  queue_as :default

  def perform header, printer_id
    # Do something later
    printer = Printer.find(printer_id.to_i)

    header.items_with_info.each do |item|
      send_to_printer printer.ip, printer.template
    end
  end
  
  def send_to_printer printer, text
    status = check_status(printer)
    if status == "OK"
      begin
        s = TCPSocket.new(printer, 9100)
        s.puts(text)
        s.close
      rescue
        Rails.logger.info "PRINTER ERROR: TIMEOUT"
      end
    else
      Rails.logger.info "PRINTER ERROR: #{status}"
    end
  end
  
  def check_status printer
    begin
      s = TCPSocket.new(printer, 9100)
      # Must create intepolation between item and template
      # Printer.template può essere anche 
      # una parola di comando epr chiedere lo stato della stampante, solo nel caso sia ok, 
      # Allora mando la stampa
      s.puts("~hs")
      # Attende per la risposta (si mette in wait)
      response = []
      while (response_text = s.gets)
        response << response_text
        break if response.count == 3
      end
      s.close
      puts response.inspect
      first = response[0].split(",")
      second = response[1].split(",")
      return "HEAD UP" if second[2].to_i == 1
      return "RIBBON OUT" if second[3].to_i == 1
      return "PAPER OUT" if first[1].to_i == 1
      return "PAUSE" if first[2].to_i == 1
      return "OK"
    rescue
      return "UNREACHABLE"
    end
  end
end
