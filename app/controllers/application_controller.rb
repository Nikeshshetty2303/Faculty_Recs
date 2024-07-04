class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # rescue_from StandardError, with: :handle_error
  # rescue_from ActionController::RoutingError, with: :handle_routing_error

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, alert: "You are not authorized to access this page."
  end

  def handle_error(exception)
    logger.error(exception) # Log the exception if needed
    redirect_to main_app.root_path, alert: "Something went wrong. Please try again later."
  end

  def handle_routing_error
    redirect_to main_app.root_path, alert: "Sorry, the page you requested does not exist."
  end

  def after_sign_in_path_for(resource)
      home_index_path
  end

end
