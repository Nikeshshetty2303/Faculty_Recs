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
      if params[:email].present?
          @user = User.find_by(email: params[:email])
          ApplicationShortlistMailer.with(user_id: @user.id, form_id: 1, dept_id: 2).applicant.deliver_later
      else
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
                ApplicationShortlistMailer.with(user_id: response.user.id, form_id: form.id, dept_id: department.id).applicant.deliver_later
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
      end
      redirect_to developer_mailer_portal_path
    end

    def application_referee_mailer
      if params[:email].present?
        @user = User.find_by(email: params[:email])
        RefereeMailer.with(user_id: @user.id, form_id: 1, dept_id: 2).applicant.deliver_now
      else
        if params[:app_nos].present?
          app_nos = params[:app_nos].split(',').map(&:strip)
          successful_apps = []
          failed_apps = []

          app_nos.each do |app_no|
            response = Response.find_by(app_no: app_no)
            if response
              begin
                profile_response = response.user.responses.find_by(profile_response: true)
                raise StandardError, "Profile response not found" unless profile_response

                name_answer = profile_response.answers.joins(:question).find_by(questions: { title: "Name in Full" })
                #referee 1:
                ref1_name = profile_response.answers.joins(:question).find_by(questions: { id: 535 })
                ref1_email = profile_response.answers.joins(:question).find_by(questions: { id: 536 })
                ref1_ph_no = profile_response.answers.joins(:question).find_by(questions: { id: 537 })
                ref1_aff = profile_response.answers.joins(:question).find_by(questions: { id: 538 })

                flash[:dark] = "candidate: #{name_answer.content} with referee, name: #{ref1_name.content}, email: #{ref1_email.content}, no. #{ref1_ph_no.content}, aff: #{ref1_aff.content}"

                RefereeMailer.with(
                  user_id: response.user.id,
                  can_name_id: name_answer.id,
                  ref_name_id: ref1_name.id,
                  ref_email_id: ref1_email.id,
                  ref_ph_no_id: ref1_ph_no.id,
                  ref_aff_id: ref1_aff.id
                ).referee.deliver_now

                response.update(referee_mail_status: true)
                flash[:success] = "Referee Mail Status: #{referee_mail_status}"
                successful_apps << app_no
              rescue StandardError => e
                Rails.logger.error("Error processing application #{app_no}: #{e.message}")
                flash[:success] = "Error processing application #{app_no}: #{e.message}"
                response.update(referee_mail_status: false)
                failed_apps << app_no
              end
            else
              failed_apps << app_no
            end
          end

          if failed_apps.empty?
            flash[:success] = "Emails sent successfully to all referees."
          elsif successful_apps.empty?
            flash[:error] = "Failed to send emails to all referees. Failed for: #{failed_apps.join(', ')}"
          else
            flash[:warning] = "Emails sent successfully to some referees. Failed for: #{failed_apps.join(', ')}"
          end
        else
          flash[:error] = "No application numbers provided."
        end
      end
      redirect_to developer_mailer_portal_path
    end

    def shortlist_mailer_status
      @user = current_user
    end
end
