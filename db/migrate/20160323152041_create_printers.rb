class CreatePrinters < ActiveRecord::Migration[4.2]
  def change
    create_table :printers do |t|
      t.string :name
      t.text :description
      t.string :ip
      t.text :template
      t.integer :qty
      t.text :translation

      t.timestamps null: false
    end
    add_index :printers, :name
    add_index :printers, :description
    add_index :printers, :ip
  end
end
