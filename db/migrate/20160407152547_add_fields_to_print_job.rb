class AddFieldsToPrintJob < ActiveRecord::Migration
  def change
    add_column :print_jobs, :errors, :boolean
    add_column :print_jobs, :description, :string
    add_index :print_jobs, :description
    add_column :print_jobs, :printed, :integer
    add_column :print_jobs, :total, :integer
  end
end
