class Admin::UsersController < Admin::AdminController

  before_action :set_user
  before_action :set_user_fields

  authorize_resource

  def destroy
    if Specimen.where(determinator_id: @user.id).count > 0 || Specimen.where(legator_id: @user.id).count > 0
      standard_destroy_response(@user, false, error: 'user.error.destroyed_has_specimens', source: params['source'])
    else
      standard_destroy_response(@user, @user.destroy, source: params['source'])
    end
  end


  private

  def set_user
    if action == :new
      @user = User.new
    elsif action == :create
      @user = User.new(resource_params)
    elsif action == :index
      @users = User.all
    else
      @user = User.friendly.find(params[:id])
    end
  end

  def set_user_fields
    if action == :index
      @fields = [
        { name: :full_name },
        { name: :email, method: :wrap_in_mail_to },
        { name: :phone },
        { name: :institution },
        { name: :role, method: :translate_value, options: { scope: [:user, :role] } },
        { name: :actions, no_label: true }
      ]
    elsif action == :show
      @fields = [
        { name: :full_name },
        { name: :title },
        { name: :email, method: :wrap_in_mail_to },
        { name: :phone },
        { name: :institution },
        { name: :role, method: :translate_value, options: { scope: [:user, :role] } }
      ]
    else
      @fields = [
        { name: :first_name },
        { name: :last_name },
        { name: :title },
        { name: :email },
        { name: :phone },
        { name: :institution },
        { name: :role, collection: User::ROLES.map { |r| [t("user.role.#{r}"), r] }, label_method: :first, value_method: :last, include_blank: false }
      ]

      if [:new, :create].include?(action_name.to_sym)
        @fields << { name: :password, as: :string }
        @fields << { name: :password_confirmation, as: :string }
      end
    end
  end

  def resource_params
    params.require(:user).permit(User::PUBLIC_FIELDS)
  end

  def current_resource
    @user
  end
end
