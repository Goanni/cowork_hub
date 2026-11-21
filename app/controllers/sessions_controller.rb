class SessionsController < ApplicationController
    before_action :redirect_if_logged_in, only: [:new, :create]
  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
	  redirect_to(session.delete(:return_to) || root_path, notice: "Вы вошли как #{user.first_name}")
    else
      flash.now[:alert] = "Неверный email или пароль"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Вы вышли из системы"
  end
end