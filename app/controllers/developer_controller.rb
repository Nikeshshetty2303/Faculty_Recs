class DeveloperController < ApplicationController
  require 'tempfile'
  require 'zip'

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
          ApplicationShortlistMailer.with(user_id: @user.id, form_id: 1, dept_id: 2).applicant.deliver_now
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
      end
      redirect_to developer_mailer_portal_path
    end

    def application_referee_mailer
      if params[:email].present? && params[:app_nos].present?
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

              # Referee 1 details
              ref1_name = profile_response.answers.joins(:question).find_by(questions: { id: 535 })
              ref1_email = profile_response.answers.joins(:question).find_by(questions: { id: 536 })
              ref1_ph_no = profile_response.answers.joins(:question).find_by(questions: { id: 537 })
              ref1_aff = profile_response.answers.joins(:question).find_by(questions: { id: 538 })

              correct_email = params[:email] ||

              ref1_status = send_referee_email(response.user.id, name_answer.id, ref1_name.id, ref1_email.id, ref1_ph_no.id, ref1_aff.id, correct_email, 1)

              if ref1_status
                response.update(referee_mail_status: "both_sent")
                flash[:success] = "Emails sent successfully to referee for application #{app_no} and email #{}."
                successful_apps << app_no
              else
                response.update(referee_mail_status: "both_failed")
                flash[:error] = "Failed to send emails to referee for application #{app_no} and email #{}."
                failed_apps << app_no
              end

            rescue StandardError => e
              Rails.logger.error("Error processing application #{app_no}: #{e.message}")
              flash[:error] = "Error processing application #{app_no}: #{e.message}"
              response.update(referee_mail_status: "error")
              failed_apps << app_no
            end
          else
            flash[:error] = "Application not found: #{app_no}"
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
      elsif params[:app_nos].present?
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

              # Referee 1 details
              ref1_name = profile_response.answers.joins(:question).find_by(questions: { id: 535 })
              ref1_email = profile_response.answers.joins(:question).find_by(questions: { id: 536 })
              ref1_ph_no = profile_response.answers.joins(:question).find_by(questions: { id: 537 })
              ref1_aff = profile_response.answers.joins(:question).find_by(questions: { id: 538 })

              # Referee 2 details
              ref2_name = profile_response.answers.joins(:question).find_by(questions: { id: 540 })
              ref2_email = profile_response.answers.joins(:question).find_by(questions: { id: 541 })
              ref2_ph_no = profile_response.answers.joins(:question).find_by(questions: { id: 542 })
              ref2_aff = profile_response.answers.joins(:question).find_by(questions: { id: 543 })

              ref1_status = send_referee_email(response.user.id, name_answer.id, ref1_name.id, ref1_email.id, ref1_ph_no.id, ref1_aff.id, 1)
              ref2_status = send_referee_email(response.user.id, name_answer.id, ref2_name.id, ref2_email.id, ref2_ph_no.id, ref2_aff.id, 2)

              if ref1_status && ref2_status
                response.update(referee_mail_status: "both_sent")
                flash[:success] = "Emails sent successfully to both referees for application #{app_no}."
                successful_apps << app_no
              elsif ref1_status
                response.update(referee_mail_status: "ref1_sent")
                flash[:warning] = "Email sent successfully to Referee 1, but failed for Referee 2 for application #{app_no}."
                failed_apps << app_no
              elsif ref2_status
                response.update(referee_mail_status: "ref2_sent")
                flash[:warning] = "Email sent successfully to Referee 2, but failed for Referee 1 for application #{app_no}."
                failed_apps << app_no
              else
                response.update(referee_mail_status: "both_failed")
                flash[:error] = "Failed to send emails to both referees for application #{app_no}."
                failed_apps << app_no
              end

            rescue StandardError => e
              Rails.logger.error("Error processing application #{app_no}: #{e.message}")
              flash[:error] = "Error processing application #{app_no}: #{e.message}"
              response.update(referee_mail_status: "error")
              failed_apps << app_no
            end
          else
            flash[:error] = "Application not found: #{app_no}"
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
      redirect_to developer_mailer_portal_path
    end

    def send_referee_email(user_id, can_name_id, ref_name_id, ref_email_id, ref_ph_no_id, ref_aff_id, correct_email, referee_number)
      begin
        RefereeMailer.with(
          user_id: user_id,
          can_name_id: can_name_id,
          ref_name_id: ref_name_id,
          ref_email_id: ref_email_id,
          ref_ph_no_id: ref_ph_no_id,
          ref_aff_id: ref_aff_id,
          correct_email: correct_email
        ).referee.deliver_now
        true
      rescue StandardError => e
        Rails.logger.error("Error sending email to Referee #{referee_number}: #{e.message}")
        false
      end
    end

    def shortlist_mailer_status
      @user = current_user
    end

    def referee_mailer_status
      @user = current_user
    end

    def extract_downloading_portal
      @user = current_user
    end


end
