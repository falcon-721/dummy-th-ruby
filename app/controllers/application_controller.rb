class ApplicationController < ActionController::Base
  include Serialized
  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :permission_error

  before_action :authenticate_user!

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  after_action :gon_user

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end

  def permission_error
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'Access denied' }
      format.any { render status: :forbidden }
    end
  end
end
