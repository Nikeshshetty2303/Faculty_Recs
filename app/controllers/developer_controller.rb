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

    def credit_questions_check
      @user = current_user
    end

    def mailer_portal
      @user = current_user
    end

    def application_shortlist_mailer
      if params[:app_nos].present?
        app_nos = params[:app_nos].split(',').map(&:strip)
        successful_apps = []
        failed_apps = []

        app_nos.each do |app_no|
          response = Response.find_by(app_no: app_no)
          if response
            begin
              department = response.form.department
              form = response.form
              ApplicationShortlistMailer.with(user_id: response.user.id, form_id: form.id, dept_id: department.id).applicant.deliver_now
              response.update(shortlist_mail_status: true)
              successful_apps << app_no
            rescue => e
              response.update(shortlist_mail_status: false)
              failed_apps << app_no
            end
          else
            failed_apps << app_no
          end
        end

        if failed_apps.empty?
          flash[:success] = "Emails sent successfully to all applicants."
        else
          flash[:warning] = "Emails sent successfully to some applicants. Failed for: #{failed_apps.join(', ')}"
        end
      else
        flash[:error] = "No application numbers provided."
      end
      redirect_to developer_mailer_portal_path
    end

    def application_referee_mailer
      redirect_to developer_mailer_portal_path
    end

    def shortlist_mailer_status
      @user = current_user
    end
end
