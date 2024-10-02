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
end