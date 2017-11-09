class ChangeColumnErrorsToPrintJob < ActiveRecord::Migration[4.2]
  def change
    rename_column :print_jobs, :errors, :iserror
  end
end
