class AdminDashboardController < ApplicationController
    def all_responses
        @user = current_user
    end

    def all_users
        @user = current_user
    end

    def statistics
        @user = current_user
        @department_stats = Department.all.each_with_object({}) do |dept, hash|
          responses = Response.joins(form: :department).where(forms: { department_id: dept.id })
          hash[dept.title] = {
            total: responses.count,
            freezed: responses.where(status: 'Freezed').count,
            free: responses.where(status: 'Free').count,
            avg_credit_score: responses.average(:credit_score).to_f.round(2)
          }
        end

        @total_freezed = Response.where(status: 'Freezed').count
        @total_free = Response.where(status: 'Free').count
      end

    def view_app_pdf
        @response = Response.find(params[:id])
        send_data @response.current_stage.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
    end

end
