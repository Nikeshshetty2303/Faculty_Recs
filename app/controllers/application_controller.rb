class ApplicationController < ActionController::Base


  before_action :authenticate_user!
  before_action :delete_unconfirmed_users
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_confirmation_notice, if: :devise_controller?
  before_action :authorize_admin
  # before_action :redirect_to_deadline

  # rescue_from StandardError, with: :handle_error
  # rescue_from ActionController::RoutingError, with: :handle_routing_error

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, alert: "You are not authorized to access this page."
  end

  def authorize_admin
    unless current_user&.role == 'admin' || devise_controller? || controller_name == 'restriction'
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  def redirect_to_deadline
    unless request.path == '/home/deadline'
      redirect_to '/home/deadline', status: :found
    end
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

  def configure_permitted_parameters
    attributes = [:photo, :sign]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  def delete_unconfirmed_users
    User.delete_unconfirmed if rand < 0.1 # Run approximately every 10th request
  end

  def set_confirmation_notice

    if devise_controller?
      if params[:action] == 'create' && params[:controller] == 'devise/registrations'
        flash[:notice] = 'Please confirm your account. Check your email for confirmation instructions.'
      elsif params[:action] == 'new' && params[:controller] == 'devise/sessions'
        if !current_user && params[:user].present? && User.find_by(email: params[:user][:email])&.confirmed_at.nil?
          flash[:notice] = 'Please confirm your account if you haven\'t already. Check your email for confirmation instructions.'
        end
      end
    end
  end

end
