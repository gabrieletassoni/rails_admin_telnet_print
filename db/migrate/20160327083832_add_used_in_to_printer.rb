class AddUsedInToPrinter < ActiveRecord::Migration
  def change
    add_column :printers, :used_in, :string
    add_index :printers, :used_in
  end
end
