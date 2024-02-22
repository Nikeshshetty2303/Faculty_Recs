class CreditValidateMailer < ApplicationMailer
    def success
        @user=User.find(params[:userid])
        mail(
                from:"nikeshs129@gmail.com" ,
                to: "#{@user.email}",
                subject: "Credit Validated"
            )
    end
    
    def failure
        @user=User.find(params[:userid])
        mail(
                from:"nikeshs129@gmail.com" ,
                to: "#{@user.email}",
                subject: "Better luck next time"
            )
    end
end
