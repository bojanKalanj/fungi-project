class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      @user = user

      if @user.supervisor?
        can :manage, :all
      else
        can [:show, :update], User, id: @user.id
        can :activate, User, id: @user.id

        can [:update, :destroy], Comment, id: @user.id
        can [:edit, :update, :destroy], Specimen, id: @user.id
      end
    end

    # can :show, :habitats
    # can :show, :substrates
    # can :show, :species_systematics
    # can :show, :stats
    #
    # can [:index, :show], Species
    # can [:index, :show], Reference
    # can [:index, :show], Characteristic
    # can [:index, :show], Location
    # can [:index, :show], Specimen
  end

end
