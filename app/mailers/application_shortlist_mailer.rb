class ApplicationShortlistMailer < ApplicationMailer
    def applicant
        @user= User.find(params[:user_id])
        @dept = Department.find(params[:dept_id])
        @form = Form.find(params[:form_id])
        mail(
            from:"facrecruit@nitk.edu.in" ,
            to: "#{@user.email}",
            #cc: User.all.pluck(:email),
            #bcc: "ok@gmail",
            subject: "Selection/Interview for Faculty Positions under Four-Tier Flexible Faculty Structure"
          )
    end

    def referee
        @user = User.find(params[:user_id])
        @can_name = Answer.find(params[:can_name_id])
        @name = Answer.find(params[:ref_name_id])
        @email = Answer.find(params[:ref_email_id])
        @ph_no = Answer.find(params[:ref_ph_no_id])
        @aff = Answer.find(params[:ref_aff_id])
        formatted_email = format_email(@email.content)
        mail(
          from: "facrecruit@nitk.edu.in",
          to: formatted_email, # Assuming the email is stored in the 'content' attribute of the Answer
          subject: "Letter of Reference"
        )
    end

    def format_email(email)
      # Remove leading/trailing whitespace
      email = email.strip

      # Remove any extra spaces within the email
      email = email.gsub(/\s+/, '')

      # Ensure there's only one @ symbol
      email = email.gsub(/@+/, '@')

      # Remove any characters that aren't typically allowed in email addresses
      email = email.gsub(/[^a-zA-Z0-9.@_+-]/, '')

      email
    end
end
