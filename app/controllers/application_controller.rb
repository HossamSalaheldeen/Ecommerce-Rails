class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :filter_parameters

    rescue_from CanCan::AccessDenied do |exception|
        respond_to do |format|
          format.json { head :forbidden }
          format.html { redirect_to main_app.root_url, :alert => exception.message }
        end
    end

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar, :name])
    end

    def filter_parameters
        @categories = Category.all
        @brands = Brand.all
        @stores = Store.all
    end
end
