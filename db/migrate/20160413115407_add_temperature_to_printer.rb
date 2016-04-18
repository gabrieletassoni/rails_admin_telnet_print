class AddTemperatureToPrinter < ActiveRecord::Migration
  def change
    add_column :printers, :temperature, :integer
  end
end
