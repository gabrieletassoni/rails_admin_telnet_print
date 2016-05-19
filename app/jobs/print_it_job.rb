class PrintItJob < ActiveJob::Base
  queue_as :default

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
    print_template = printer.print_template
    #Rails.logger.info "MOMERDA 2: #{model_name.constantize.inspect}"
    header = model_name.constantize.find(id)
    items = header.items_with_info.order(code: :asc)
    @printed = 0

    @pjob = PrintJob.create(printer_id: printer.id, finished: false, iserror: false, total: ((items.count.to_f / print_template.number_of_barcodes).ceil rescue 0), printed: @printed)
    # Spezzetto l'array degli items in gruppi di number_of_barcodes
    # Rails.logger.info "BELLAAAAAAA! #{items.group_by.with_index{|_, i| i % print_template.number_of_barcodes}.values.inspect}"
    items.each_slice(print_template.number_of_barcodes) do |item_group|
      # Rails.logger.info "ITEMGROUP: #{item_group.inspect}"
      barcodes = item_group.map(&:id)
      barcodes = barcodes.fill("", barcodes.length..(print_template.number_of_barcodes - 1)) if print_template.number_of_barcodes > barcodes.length
      # Rails.logger.info "AAAAHHHHHHHHHH: #{barcodes.inspect}"
      translation = print_template.translate(header: header, items: barcodes, temperature: printer.temperature)
      # Rails.logger.info "BARCODES: #{barcodes.inspect}"
      result = send_to_printer printer.ip, translation
      # Se il risultato è un errore, allora mi fermo completamente e loggo il numero di particolari stampati
      # Rails.logger.info "RISULTATO: #{result}"
      break unless result
    end
    @pjob.update(printed: @printed)
    @pjob.update(finished: true)
  end

  def send_to_printer printer, text
    status = check_status(printer)
    if status == "OK"
      begin
        s = TCPSocket.new(printer, 9100)
        # Rails.logger.debug "TEMPERATURE: #{text}"
        s.puts(text)
        s.close
        @printed += 1
        return true
      rescue
        @pjob.update(iserror: true, description: "PRINTER ERROR: TIMEOUT")
        return false
      end
    else
      @pjob.update(iserror: true, description: "PRINTER ERROR: #{status}")
      return false
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
