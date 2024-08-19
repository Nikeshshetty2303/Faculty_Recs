class DeveloperController < ApplicationController
    def csv_generator
        @user = current_user
    end

end
