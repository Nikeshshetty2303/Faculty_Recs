class AdminDashboardController < ApplicationController
    def all_responses
        @user = current_user
    end

    def view_app_pdf
        @response = Response.find(params[:id])
        send_data @response.current_stage.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
    end

end
