class AddPrintTemplateIdToPrinter < ActiveRecord::Migration
  def change
    add_reference :printers, :print_template, index: true, foreign_key: true
  end
end
