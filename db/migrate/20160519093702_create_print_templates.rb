class CreatePrintTemplates < ActiveRecord::Migration
  def change
    create_table :print_templates do |t|
      t.string :name
      t.text :description
      t.text :template
      t.integer :number_of_barcodes
      t.text :translation_matrix

      t.timestamps null: false
    end
  end
end
