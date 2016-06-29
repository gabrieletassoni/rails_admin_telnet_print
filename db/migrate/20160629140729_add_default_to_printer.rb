class AddDefaultToPrinter < ActiveRecord::Migration
  def change
    add_column :printers, :default, :boolean, default: false
  end
end
