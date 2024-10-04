class CreditValidateMailer < ApplicationMailer
    def success
        @user=User.find(params[:userid])
        mail(
                from:"facrecruit@nitk.edu.in" ,
                to: "#{@user.email}",
                subject: "Credit Validated"
            )
    end

    def failure
        @user=User.find(params[:userid])
        mail(
                from:"facrecruit@nitk.edu.in" ,
                to: "#{@user.email}",
                subject: "Better luck next time"
            )
    end
end
