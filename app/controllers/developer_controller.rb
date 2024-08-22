class DeveloperController < ApplicationController
    def csv_generator
        @user = current_user
    end

    def multiple_app_user
        @user = current_user
    end
end
