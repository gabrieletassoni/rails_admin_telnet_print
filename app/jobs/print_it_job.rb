class PrintItJob < ApplicationJob
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
    Rails.logger.info "PrintItJob: PRINTING MODEL: #{model_name.constantize.inspect}"
    header = model_name.constantize.find(id)
    items = header.records_for_print(id).order(code: :asc)

    pivot = []
    @pjob = PrintJob.create(printer_id: printer.id, finished: false, iserror: false, total: 0, printed: 0)
    # Spezzetto l'array degli items in gruppi di number_of_barcodes
    # Rails.logger.info "BELLAAAAAAA! #{items.group_by.with_index{|_, i| i % print_template.number_of_barcodes}.values.inspect}"
    items.each_slice(print_template.number_of_barcodes) do |item_group|
      # Rails.logger.info "ITEMGROUP: #{item_group.inspect}"
      barcodes = item_group.map(&:id)
      barcodes = barcodes.fill("", barcodes.length..(print_template.number_of_barcodes - 1)) if print_template.number_of_barcodes > barcodes.length
      # Rails.logger.info "AAAAHHHHHHHHHH: #{barcodes.inspect}"
      pivot.push print_template.translate(header: header, items: barcodes, temperature: printer.temperature)
      # Rails.logger.info "BARCODES: #{barcodes.inspect}"
      # Se il risultato è un errore, allora mi fermo completamente e loggo il numero di particolari stampati
      # Rails.logger.info "RISULTATO: #{result}"
    end

    Rails.logger.info "PrintItJob: SENDING TO PRINTER, TEXT TO PRINT IS:\n #{pivot.inspect}"
    result = pivot.empty? ? false : send_to_printer(printer.ip, pivot.join(""))
    @pjob.update(printed: (result ? pivot.length : 0)) # Se risultato true, allora ha stampato tutto, altrimenti non ha stampato nulla
    @pjob.update(total: pivot.length) # In realtà è inutile, ora manda tutto quello che può alla stampante, solo lei può andare storta
    @pjob.update(finished: result)
  end

  def send_to_printer printer, text
    status = check_status(printer)
    if status == "OK"
      begin
        s = TCPSocket.new(printer, 9100)
        # Rails.logger.debug "TEMPERATURE: #{text}"
        s.puts(text)
        s.close
        # @printed += 1
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
      Rails.logger.info response.inspect
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
