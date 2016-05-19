TheCoreAbilities.module_eval do
  def telnet_print_abilities user
    if user && user.admin?
      cannot [ :create, :update, :destroy, :show, :clone ], PrintJob
    end
  end
end
