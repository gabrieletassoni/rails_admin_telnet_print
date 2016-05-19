class PrintJob < ActiveRecord::Base
  belongs_to :printer, inverse_of: :print_jobs

  def printed_on_total
    "#{printed}/#{total}"
  end

  rails_admin do
    navigation_label I18n.t(:advanced)
    parent Printer
    weight 13

    field :printer
    field :created_at
    field :description
    field :printed_on_total
  end
end
