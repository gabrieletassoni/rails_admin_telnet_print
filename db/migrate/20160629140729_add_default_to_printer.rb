class AddDefaultToPrinter < ActiveRecord::Migration[4.2]
  def change
    add_column :printers, :default, :boolean, default: false
  end
end
