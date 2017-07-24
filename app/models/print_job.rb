class PrintJob < ApplicationRecord
  belongs_to :printer, inverse_of: :print_jobs

  def printed_on_total
    "#{printed}/#{total}"
  end

  RailsAdmin.config do |config|
    config.model 'PrintJob' do
    # rails_admin do
      navigation_label I18n.t("admin.settings.label")
      navigation_icon 'fa fa-check-square'
      parent Printer
      weight 13

      field :printer
      field :created_at
      field :description
      field :printed_on_total
    end
  end
end
