class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    @user.role = Role.find_by(name: "member")

    if @user.save
      session[:user_id] = @user.id
      redirect_to(session.delete(:return_to) || root_path,
                  notice: "Добро пожаловать, #{@user.first_name}!")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :first_name, :last_name, :phone)
  end
end