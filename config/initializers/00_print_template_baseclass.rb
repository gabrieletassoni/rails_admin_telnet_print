class PrintTemplate
  def self.inherited(klass)
    @descendants ||= []
    @descendants << klass
  end

  def self.descendants
    @descendants || []
  end

  def self.template
    @TEMPLATE
  end

  def self.number_of_barcodes
    @NUMBEROFBARCODES
  end

  def self.translate args
    # Rails.logger.info("COME CAZZO SEI FATTO? #{args.inspect}")
    temp = @TEMPLATE.clone
    temp.gsub!("TEMPERATURE", args[:temperature].to_s)
    @NUMBEROFBARCODES.times.with_index do |i|
      #Rails.logger.debug "MAMAMAMA! #{args[:items][i]}"
      item = (ChosenItem.find(args[:items][i]) rescue false)
      @TRANSLATIONMATRIX.each_pair do |k, v|
        Rails.logger.debug "ITEM: #{item.inspect} AND THE STRING: #{v}"
        temp.gsub!(k, item.is_a?(FalseClass) ? "" : v.split(".").inject(item, :send))
      end
      # Rails.logger.debug "MAMAMAMA! #{item.inspect}"
      # Se item è stringa vuota (quindi non ha .barcode), allora ritorna il campo FD remmato
      temp.gsub!("^FD>:BARCODE#{i.to_s.rjust(2, '0')}^FS", ("^FD>:#{item.barcode}^FS" rescue "@FD>:^FS"))
    end
    Rails.logger.info temp
    temp
  end
end
