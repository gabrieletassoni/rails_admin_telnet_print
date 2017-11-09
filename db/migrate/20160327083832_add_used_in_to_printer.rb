class AddUsedInToPrinter < ActiveRecord::Migration[4.2]
  def change
    add_column :printers, :used_in, :string
    add_index :printers, :used_in
  end
end
