class AdminDashboardController < ApplicationController
    def all_responses
        @user = current_user
    end
end
