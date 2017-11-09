class AddFieldsToPrintJob < ActiveRecord::Migration[4.2]
  def change
    add_column :print_jobs, :errors, :boolean
    add_column :print_jobs, :description, :string
    add_index :print_jobs, :description
    add_column :print_jobs, :printed, :integer
    add_column :print_jobs, :total, :integer
  end
end
