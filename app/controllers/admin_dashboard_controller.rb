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

    def extract_portal
      @user = current_user
    end

    def view_summary_report_csv
      @form = Form.find(params[:form_id])
      @responses = @form.responses

      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.add_worksheet(name: "Summary Report") do |sheet|
        styles = create_styles(workbook)

        # Second row: Question headers
        headers = ["Application ID"]
        headers += [
          "Undergraduate", "Postgraduate", "PhD", "PostDoc",
          "Experience Type/Institute Ranking", "Major Awards / Fellowship",
          "Academic Credentials", "Academic Credentials Comments",
          "Professional Experience", "Professional Experience Comments",
          "Credit Requirements", "Credit Requirements Comments",
          "Eligibility", "Remark"
        ]
        sheet.add_row headers, style: styles[:header]

        # Data rows
        @responses.each_with_index do |response, index|
          row_data = [response.app_no]

          row_data += [
            response.undergraduate,
            response.postgraduate,
            response.phd,
            response.postdoc,
            response.experience_type,
            response.major_awards,
            response.academic_experience ? "S" : (response.academic_experience == false ? "N" : ""),
            response.acad_exp_comments,
            response.professional_experience ? "S" : (response.professional_experience == false ? "N" : ""),
            response.prof_exp_comments,
            response.credit_requirements ? "S" : (response.credit_requirements == false ? "N" : ""),
            response.credit_req_comments,
            response.eligibility == "1" ? "Y" : (response.eligibility == 'Yes' ? "Y" : (response.eligibility == 'TBD' ? 'TBD' : 'N')),
            response.remark
          ]

          row_style = index.even? ? styles[:even_row] : styles[:odd_row]
          sheet.add_row row_data, style: row_style
        end

        # # Apply column widths
        # total_question_count = @credit_sections.sum { |section| section.credit_questions.where(isheader: nil).count }
        # sheet.column_widths 15, *([12] * (total_question_count * 4)), *([15] * 14)
      end
      send_data package.to_stream.read, type: "application/xlsx", filename: "#{@form.department.title}_#{@form.role}_report.xlsx"
    end

    def create_styles(workbook)
      {
        header: workbook.styles.add_style(
          bg_color: "4472C4",
          fg_color: "FFFFFF",
          b: true,
          alignment: { horizontal: :center, vertical: :center, wrap_text: true },
          border: { style: :thin, color: "FFFFFF" }
        ),
        sub_header: workbook.styles.add_style(
          bg_color: "D9E1F2",
          fg_color: "44546A",
          b: true,
          alignment: { horizontal: :center, vertical: :center, wrap_text: true },
          border: { style: :thin, color: "FFFFFF" }
        ),
        even_row: workbook.styles.add_style(
          bg_color: "F2F2F2",
          alignment: { horizontal: :left, vertical: :center, wrap_text: true },
          border: { style: :thin, color: "E6E6E6" }
        ),
        odd_row: workbook.styles.add_style(
          bg_color: "FFFFFF",
          alignment: { horizontal: :left, vertical: :center, wrap_text: true },
          border: { style: :thin, color: "E6E6E6" }
        )
      }
    end

end
