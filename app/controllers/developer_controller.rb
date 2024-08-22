class DeveloperController < ApplicationController
    def csv_generator
        @user = current_user
    end

    def multiple_app_user
        @user = current_user
    end

    def extract_print
        @response = Response.find(params[:id])
        @user = User.find(params[:userid])
        @app_response = Response.where(user_id: @user.id, profile_response: true).last
        if @user.photo.attached?
          @user_photo_base64 = Base64.strict_encode64(@user.photo.download)
        else
          @user_photo_base64 = nil
        end

        if @user.sign.attached?
          @user_sign_base64 = Base64.strict_encode64(@user.sign.download)
        else
          @user_sign_base64 = nil
        end

        respond_to do |format|
            format.html
            format.pdf do
              render pdf: 'Extract Pdf', # file name
                     template: 'developer/extractpdf.html.erb',
                     layout: 'layouts/pdf.html.erb', # optional, use 'pdf.html' for a simple layout
                     disposition: 'inline',
                     locals: { response: @response, user: @user, app_response: @app_response},
                    margin: { top: 0, bottom: 0, left: 0, right: 0 } # 'attachment' to download, 'inline' to display in the browser
            end
          end
      end
end
