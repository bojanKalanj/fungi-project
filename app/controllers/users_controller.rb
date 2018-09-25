class UsersController < ApplicationController

  before_action :set_user
  before_action :get_specimens

  authorize_resource

  def show
    @user = User.friendly.find(params[:id])
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    @user = User.friendly.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to root_path
      flash[:notice] = "Uspesno ste izmenili profil..."
    else
      flash[:danger] = "Ne valja ti poso"
    end
  end

  private

  def set_user
    if params[:action] == :new
      @user = User.new
    elsif params[:action] == :create
      @user = User.new(user_params)
    elsif params[:action] == :index
      @users = User.all
    else
      @user = User.friendly.find(params[:id])
    end
  end

  def user_params
    params.require(:user).permit(User::PUBLIC_FIELDS)
  end

  def get_specimens
    @specimens = Specimen.where(legator_id: @user.id).paginate(:page => params[:page], per_page: 12 )
  end
end
