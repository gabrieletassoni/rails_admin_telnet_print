class AddTemperatureToPrinter < ActiveRecord::Migration[4.2]
  def change
    add_column :printers, :temperature, :integer
  end
end
