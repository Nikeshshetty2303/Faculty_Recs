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
        flash[:notice] = "HEREE"
        mail(
          from: "facrecruit@nitk.edu.in",
          to: @email.content, # Assuming the email is stored in the 'content' attribute of the Answer
          subject: "Letter of Reference"
        )
    end
end
