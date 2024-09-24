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
      @responses = @form.responses.where(status: "Freezed")

      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.add_worksheet(name: "Summary Report") do |sheet|
        styles = create_styles(workbook)

        headers = ["Application ID"]
        headers += ["Name", "Category"]
        headers += [
          "Undergraduate", "Postgraduate", "PhD", "PostDoc",
          "Experience Type/Institute Ranking", "Credit Points (Claimed)", "Credit Points (After Scrutiny)", "Major Awards / Fellowship",
          "Academic Credentials", "Academic Credentials Comments",
          "Professional Experience", "Professional Experience Comments",
          "Credit Requirements", "Credit Requirements Comments",
          "Eligibility", "Remark"
        ]
        sheet.add_row headers, style: styles[:header]

        # Initialize an array to store the maximum width of each column
        max_widths = headers.map { |header| [header.length, 10].max }

        # Data rows
        @responses.each_with_index do |response, index|
          row_data = [response.app_no]

          profile_response = response.user.responses.where(profile_response: true).first
          name_answer = profile_response.answers.joins(:question).find_by(questions: { title: "Name in Full" })
          cat_answer = profile_response.answers.joins(:question).find_by(questions: { title: " Category" })
          row_data += [name_answer ? name_answer.content : "Not Entered"]
          row_data += [cat_answer ? cat_answer.content : "Not Entered"]


          row_data += [
            response.undergraduate,
            response.postgraduate,
            response.phd,
            response.postdoc,
            response.experience_type,
            response.credit_score.round(1),
            response.validated_credit_score ? response.validated_credit_score.round(1) : response.validated_credit_score,
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

          # Update max_widths based on the content of each cell
          row_data.each_with_index do |cell_value, col_index|
            cell_width = cell_value.to_s.length
            max_widths[col_index] = [max_widths[col_index], cell_width].max
          end

          row_style = index.even? ? styles[:even_row] : styles[:odd_row]
          sheet.add_row row_data, style: row_style
        end

        # Set column widths
        sheet.column_widths(*max_widths.map { |width| [width + 2, 50].min })
      end

      send_data package.to_stream.read, type: "application/xlsx", filename: "#{@form.department.title}_#{@form.role}_report.xlsx"
    end

    def export_department_excel
      department = Department.find(params[:id])

      app_group = Response.joins(form: :department)
                          .where(status: "Freezed")
                          .where(departments: { id: department.id })
                          .group_by(&:form)
                          .transform_values { |responses| responses.sort_by { |r| r.app_no.to_s.strip } }

      forms_data = app_group.map do |form, responses|
        categories = responses.each_with_object(Hash.new(0)) do |response, counts|
          profile_response = response.user.responses.find_by(profile_response: true)
          if profile_response
            cat_answer = profile_response.answers.joins(:question).find_by(questions: { title: " Category" })
            counts[cat_answer&.content] += 1 if cat_answer
          end
        end

        {
          role: form.role,
          gen: categories["GEN"],
          sc: categories["SC"],
          st: categories["ST"],
          obc: categories["OBC"],
          not_entered: responses.count - categories.values.sum,
          total: responses.count
        }
      end

      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.add_worksheet(name: "Department Summary") do |sheet|
        styles = create_styles(workbook)

        # Add headers
        headers = ["Role", "GEN", "SC", "ST", "OBC", "Not Entered", "Total"]
        sheet.add_row headers, style: styles[:header]

        # Add data rows
        forms_data.each_with_index do |form_data, index|
          row_data = [
            form_data[:role],
            form_data[:gen],
            form_data[:sc],
            form_data[:st],
            form_data[:obc],
            form_data[:not_entered],
            form_data[:total]
          ]
          row_style = index.even? ? styles[:even_row] : styles[:odd_row]
          sheet.add_row row_data, style: row_style
        end

        # Add total row
        total_row = [
          "Total",
          forms_data.sum { |form| form[:gen] },
          forms_data.sum { |form| form[:sc] },
          forms_data.sum { |form| form[:st] },
          forms_data.sum { |form| form[:obc] },
          forms_data.sum { |form| form[:not_entered] },
          forms_data.sum { |form| form[:total] }
        ]
        sheet.add_row total_row, style: styles[:sub_header]

        # Set column widths
        sheet.column_widths 20, 10, 10, 10, 10, 15, 10
      end

      send_data package.to_stream.read, type: "application/xlsx", filename: "#{department.title}_applications.xlsx"
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



    def application_summary_table
      @user = current_user
    end

    def department_data
      department = Department.find(params[:id])

      app_group = Response.joins(form: :department)
                          .where(status: "Freezed")
                          .where(departments: { id: department.id })
                          .group_by(&:form)
                          .transform_values { |responses| responses.sort_by { |r| r.app_no.to_s.strip } }

      forms_data = app_group.map do |form, responses|
        categories = responses.each_with_object(Hash.new(0)) do |response, counts|
          profile_response = response.user.responses.find_by(profile_response: true)
          if profile_response
            cat_answer = profile_response.answers.joins(:question).find_by(questions: { title: " Category" })
            counts[cat_answer&.content] += 1 if cat_answer
          end
        end

        gen = categories["GEN"]
        sc = categories["SC"]
        st = categories["ST"]
        obc = categories["OBC"]
        not_entered = responses.count - gen - sc - st - obc

        {
          role: form.role,
          gen: gen,
          sc: sc,
          st: st,
          obc: obc,
          not_entered: not_entered,
          total: responses.count
        }
      end

      total_applications = forms_data.sum { |form| form[:total] }

      render json: {
        department_id: department.id,
        department_title: department.title,
        forms: forms_data,
        total_gen: forms_data.sum { |form| form[:gen] },
        total_sc: forms_data.sum { |form| form[:sc] },
        total_st: forms_data.sum { |form| form[:st] },
        total_obc: forms_data.sum { |form| form[:obc] },
        total_not_entered: forms_data.sum { |form| form[:not_entered] },
        total_applications: total_applications
      }
    end

end
