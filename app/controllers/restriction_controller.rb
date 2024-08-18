class RestrictionController < ApplicationController
    def frozen_application
        @user = User.find(current_user.id)
        @responses = Response.where(user_id: @user.id)
    end

    def view_frozen_app_pdf
        @response = Response.find(params[:id])
        send_data @response.current_stage.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
    end

      def view_frozen_combined_pdf
        @response = Response.find(params[:id])
        send_data @response.combined_pdf.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
      end

end
