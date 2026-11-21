class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes
  helper_method :current_user, :logged_in?, :admin?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  def logged_in?
    current_user.present?
  end
  def admin?
    logged_in? && current_user.role.name == "admin"
  end
  def require_login
    unless logged_in?
      session[:return_to] = request.fullpath
      redirect_to login_path, alert: "Сначала войдите в систему"
    end
  end
  def require_admin
    unless admin?
      redirect_to root_path, alert: "Доступ только для администратора"
    end
  end
  def redirect_if_logged_in
    if logged_in?
      redirect_to root_path, notice: "Вы уже вошли как #{current_user.first_name}"
    end
  end
end