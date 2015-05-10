class Admin::UsersController < ApplicationController
  include StandardResponses

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user_fields
  before_action :authenticate_user!

  def index
    @users = User.all

    @user_fields = [
      { name: :full_name },
      { name: :email, method: :wrap_in_mail_to },
      { name: :phone },
      { name: :institution },
      { name: :role, method: :translate_value, options: { scope: [:user, :role] } },
      { name: :actions, no_label: true }
    ]
  end

  def show
    @user_fields = [
      { name: :full_name },
      { name: :title },
      { name: :email, method: :wrap_in_mail_to },
      { name: :phone },
      { name: :institution },
      { name: :role, method: :translate_value, options: { scope: [:user, :role] } }
    ]
    standard_nil_record_response(User) if @user.nil?
  end

  def new
    @user = User.new
  end

  def edit
    standard_nil_record_response(User) if @user.nil?
  end

  def create
    @user = User.new(user_params)
    standard_create_response @user, @user.save, fields: @user_fields
  end

  def update
    standard_update_response @user, @user.update(user_params), fields: @user_fields
  end

  def destroy
    if Specimen.where(determinator_id: @user.id).count > 0 || Specimen.where(legator_id: @user.id).count > 0
      standard_destroy_response(@user, false, error: 'user.error.destroyed_has_specimens', source: params['source'])
    else
      standard_destroy_response(@user, @user.destroy, source: params['source'])
    end
  end


  private

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def set_user_fields
    @user_fields = [
      { name: :first_name },
      { name: :last_name },
      { name: :title },
      { name: :email },
      { name: :phone },
      { name: :institution },
      { name: :role, collection: User::ROLES.map { |r| [t("user.role.#{r}"), r] }, label_method: :first, value_method: :last, include_blank: false }
    ]

    if [:new, :create].include?(action_name.to_sym)
      @user_fields << { name: :password, as: :string }
      @user_fields << { name: :password_confirmation, as: :string }
    end
  end

  def user_params
    params.require(:user).permit(User::PUBLIC_FIELDS)
  end
end
