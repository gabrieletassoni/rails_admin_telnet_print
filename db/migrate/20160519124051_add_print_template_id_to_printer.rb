class AddPrintTemplateIdToPrinter < ActiveRecord::Migration[4.2]
  def change
    add_reference :printers, :print_template, index: true, foreign_key: true
  end
end
