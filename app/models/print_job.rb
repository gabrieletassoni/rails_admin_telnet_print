class PrintJob < ActiveRecord::Base
  belongs_to :printer, inverse_of: :print_jobs

  rails_admin do
    navigation_label I18n.t(:advanced)
    parent Printer
    weight 12

    list do
      configure :updated_at do
        visible false
      end
    end
  end
end
