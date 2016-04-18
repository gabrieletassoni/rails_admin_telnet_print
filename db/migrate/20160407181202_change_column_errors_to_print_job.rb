class ChangeColumnErrorsToPrintJob < ActiveRecord::Migration
  def change
    rename_column :print_jobs, :errors, :iserror
  end
end
