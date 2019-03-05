class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if current_user.admin?
      root_path
    else
      company_share_catalogs_path(current_user)
    end
  end
end
