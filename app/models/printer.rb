class Printer < ApplicationRecord
  #serialize :translation, Hash

  has_many :print_jobs, dependent: :destroy, inverse_of: :printer
  belongs_to :print_template, inverse_of: :printers

  validates :name, presence: true
  validates :ip, presence: true
  validates :temperature, presence: true
  validates :print_template, presence: true

  # before_save :check_if_unique_default
  # validates :qty, presence: true, numericality: { only_integer: true, greater_than: 0 }
  # validates :translation, presence: true

  # def template_enum
  #   PrintTemplate.descendants
  # end
  #
  # # Array holding all the roles
  # USED = %i[
  #   bundle
  #   commission
  # ]
  #
  # def used_in_enum
  #   # Do not EDIT below this line
  #   USED.each_with_index.map {|a,i| [I18n.t("used_in.#{a.to_sym}"), (i+1).to_s]}
  # end
  # def has_section? section
  #     # example called from cancan's app/models/ability.rb
  #     # if user.has_role? :admin
  #
  #     # for roles array stored in db... take each value, see if it matches the second column in the roles_enum array, if so, retu the 1st col of the enum as a uprcase,space_to_underscore,symbol .
  #     USED[self.used_in.to_i - 1].to_s == section.to_s
  # end
  #
  # def self.assigned_to section
  #   where(used_in: (USED.index(section.to_sym) + 1))
  # end

  RailsAdmin.config do |config|
    config.model 'Printer' do
      navigation_label I18n.t("admin.settings.label")
      navigation_icon 'fa fa-print'
      weight 11

      field :name
      field :ip
      field :default, :toggle
      field :temperature
      field :print_template
      # field :used_in
      field :description

      list do
        configure :description do
          visible false
        end
      end
    end
  end
  # private
  # def check_if_unique_default
  #   if self.default?
  #     Printer.where.not(id: self.id)
  #   end
  # end
end
