class PrintJob < ActiveRecord::Base
  belongs_to :printer, inverse_of: :printers
  
  rails_admin do
    navigation_label I18n.t(:advanced)
    parent Printer
    
    edit do
      visible false
    end
    
    show do
      visible false
    end
  end
end
