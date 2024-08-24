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
            free: responses.where(status: 'Free').where.not(form_id: nil).count,
            avg_credit_score: responses.average(:credit_score).to_f.round(2)
          }
        end

        @total_freezed = Response.where(status: 'Freezed').count
        @total_free = Response.where(status: 'Free').where.not(form_id: nil).count
    end

    def view_app_pdf
        @response = Response.find(params[:id])
        send_data @response.current_stage.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
    end

    def view_summary_report
        @form = Form.find(params[:form_id])
        respond_to do |format|
            format.html
            format.pdf do
              render pdf: 'Verified Summary Report', # file name
                     template: 'admin_dashboard/summary_report.html.erb',
                     layout: 'layouts/pdf.html.erb', # optional, use 'pdf.html' for a simple layout
                     disposition: 'inline',
                     locals: {form: @form},
                    margin: { top: 0, bottom: 0, left: 0, right: 0 } # 'attachment' to download, 'inline' to display in the browser
            end
          end
    end

    def extract_print
      @response = Response.find(params[:id])
      @user = User.find(params[:userid])
      @app_response = Response.where(user_id: @user.id, profile_response: true).last
      
      respond_to do |format|
          format.html
          format.pdf do
            render pdf: 'Extract Pdf', # file name
                   template: 'admin_dashboard/extractpdf.html.erb',
                   layout: 'layouts/pdf.html.erb', # optional, use 'pdf.html' for a simple layout
                   disposition: 'inline',
                   locals: { response: @response, user: @user, app_response: @app_response},
                  margin: { top: 0, bottom: 0, left: 0, right: 0 } # 'attachment' to download, 'inline' to display in the browser
          end
        end
    end

end
