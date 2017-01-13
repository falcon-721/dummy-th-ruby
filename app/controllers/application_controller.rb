class ApplicationController < ActionController::Base
  include Serialized
  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :permission_error

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :gon_user, unless: :devise_controller?

  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end

  def permission_error
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'Access denied' }
      format.js { render status: :forbidden, plain: 'Access denied' }
      format.json { render status: :forbidden, plain: 'Access denied' }
    end
  end
end
