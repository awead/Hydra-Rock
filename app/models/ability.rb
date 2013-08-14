class Ability
  include Hydra::Ability

  def create_permissions
    can :create, :all if user_groups.include? 'archivist'
  end

end