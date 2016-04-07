class Printer < ActiveRecord::Base
  serialize :translation, Hash
  
  has_many :print_jobs, dependent: :destroy, inverse_of: :printer
  
  validates :name, presence: true
  validates :ip, presence: true
  validates :template, presence: true
  validates :qty, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :translation, presence: true

  # Array holding all the roles
  USED = %i[
    bundle
    commission
  ]
  
  def used_in_enum
    # Do not EDIT below this line
    USED.each_with_index.map {|a,i| [I18n.t("used_in.#{a.to_sym}"), (i+1).to_s]}
  end
  def has_section? section
      # example called from cancan's app/models/ability.rb
      # if user.has_role? :admin

      # for roles array stored in db... take each value, see if it matches the second column in the roles_enum array, if so, retu the 1st col of the enum as a uprcase,space_to_underscore,symbol .
      USED[self.used_in.to_i - 1].to_s == section.to_s
  end
  
  def self.assigned_to section
    where(used_in: (USED.index(section.to_sym) + 1))
  end
  
  rails_admin do
    navigation_label I18n.t(:advanced)
    weight 11
  end
end
