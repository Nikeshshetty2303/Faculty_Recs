class PaymentMailer < ApplicationMailer
    def payment
        @user=User.find(params[:user_id])
        @response = Response.find(params[:response_id])
        @form = Form.find(params[:form_id])
        mail(
                from:"facrecruit@nitk.edu.in" ,
                to: "#{@user.email}",
                subject: "Payment Completed"
            )
    end
end
