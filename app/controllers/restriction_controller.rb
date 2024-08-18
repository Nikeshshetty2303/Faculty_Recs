class RestrictionController < ApplicationController
    def frozen_application
        @user = User.find(current_user.id)
        @responses = Response.where(user_id: @user.id)
    end

end
