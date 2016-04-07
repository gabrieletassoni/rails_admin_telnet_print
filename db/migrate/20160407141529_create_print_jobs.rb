class CreatePrintJobs < ActiveRecord::Migration
  def change
    create_table :print_jobs do |t|
      t.boolean :finished
      t.references :printer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
