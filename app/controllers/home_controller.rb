class HomeController < ApplicationController
  def index
    @user = User.find(current_user.id)
    @forms = Form.all
    @departments = Department.all
    @announcement = Announcement.find(1)

    redirect_to home_validate_path
  end

  def app_profile
    @user = User.find(current_user.id)
    if @user.tab_no == 1
      @response = Response.new
      @tab= Tab.find(@user.tab_no)
    else
      @response = Response.find(params[:res_id])
      @user.nav_tab_no = params[:nav_tab_no]
      @tab= Tab.find(@user.nav_tab_no)
      @user.save
    end
    @questions = Question.all
  end

  def instruction
    @user = current_user
  end

  def edit_app_profile
    @user = User.find(current_user.id)
    @response = Response.where(id: @res_id)
    @questions = Question.all
    tab_no = current_user.tab_no
    @tab= Tab.find(@user.tab_no)
  end

  def validate
    @user = User.find(current_user.id)
    @response = Response.all
  end

  def deadline

  end

  def export_to_excel
    @credit_sections = CreditSection.all
    @credit_questions = CreditQuestion.where(isheader: nil)

    @responses = Response.joins(form: :department)
                     .where(form: { departments: { title: current_user.validator } }, status: "Freezed")
                     .includes(credit_answers: :credit_question)
                     .sort_by { |response| response.app_no.to_s.strip }

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Credit Data") do |sheet|
      styles = create_styles(workbook)

      # First row: Section headers
      sections = [""] + @credit_sections.flat_map do |section|
        question_count = section.credit_questions.where(isheader: nil).count
        [section.title] + Array.new((question_count * 4) - 1, "")
      end
      sheet.add_row sections, style: styles[:header]

      # Merge cells for section headers
      start_column = 1 # Start after Application ID
      @credit_sections.each do |section|
        question_count = section.credit_questions.where(isheader: nil).count
        end_column = start_column + (question_count * 4) - 1
        sheet.merge_cells("#{Axlsx::col_ref(start_column)}1:#{Axlsx::col_ref(end_column)}1")
        start_column = end_column + 1
      end

      # Second row: Question headers
      headers = ["Application ID"]
      @credit_sections.each do |section|
        section.credit_questions.where(isheader: nil).each do |question|
          headers += [question.title, "", "", ""]
        end
      end
      headers += [
        "Undergraduate", "Postgraduate", "PhD",
        "Experience Type/Institute Ranking", "Major Awards / Fellowship",
        "Academic Credentials", "Academic Credentials Comments",
        "Professional Experience", "Professional Experience Comments",
        "Credit Requirements", "Credit Requirements Comments","Specialization",
        "Eligibility", "Remark"
      ]
      sheet.add_row headers, style: styles[:header]

      # Merge cells for question headers
      start_column = 1 # Start after Application ID
      @credit_sections.each do |section|
        section.credit_questions.where(isheader: nil).each do |question|
          end_column = start_column + 3
          sheet.merge_cells("#{Axlsx::col_ref(start_column)}2:#{Axlsx::col_ref(end_column)}2")
          start_column = end_column + 1
        end
      end

      # Third row: Sub-headers
      sub_headers = [""] + @credit_sections.flat_map do |section|
        section.credit_questions.where(isheader: nil).map do |question|
          ["Count", "Verified Count", "Credit", "Verified Credit"]
        end
      end.flatten
      sub_headers += [""] * 14 # For the static headers
      sheet.add_row sub_headers, style: styles[:sub_header]

      # Data rows
      @responses.each_with_index do |response, index|
        row_data = [response.app_no]

        @credit_sections.each do |section|
          section.credit_questions.where(isheader: nil).each do |question|
            answer = response.credit_answers.find { |a| a.credit_question_id == question.id }
            if answer.present?
              row_data += [
                answer.answer.to_f,
                answer.verified_count.to_f,
                answer.credit.to_f,
                answer.verified_credit.to_f
              ]
            else
              row_data += [nil, nil, nil, nil]
            end
          end
        end

        row_data += [
          response.undergraduate,
          response.postgraduate,
          response.phd,
          response.experience_type,
          response.major_awards,
          response.academic_experience ? "S" : (response.academic_experience == false ? "N" : ""),
          response.acad_exp_comments,
          response.professional_experience ? "S" : (response.professional_experience == false ? "N" : ""),
          response.prof_exp_comments,
          response.credit_requirements ? "S" : (response.credit_requirements == false ? "N" : ""),
          response.specialization ? "S" : (response.specialization ==false ? "N" : ""),
          response.credit_req_comments,
          response.eligibility,
          response.remark
        ]

        row_style = index.even? ? styles[:even_row] : styles[:odd_row]

        # Specify types for each cell
        types = [:string] # For Application ID
        types += ([:float] * (@credit_questions.count * 4)) # For all numeric fields
        types += ([:string] * 14) # For the remaining fields

        sheet.add_row row_data, style: row_style, types: types
      end

      # Apply column widths
      total_question_count = @credit_sections.sum { |section| section.credit_questions.where(isheader: nil).count }
      sheet.column_widths 15, *([12] * (total_question_count * 4)), *([15] * 14)
    end

    send_data package.to_stream.read, type: "application/xlsx", filename: "Credit_data_#{current_user.validator}.xlsx"
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
  end  # respond_to do |format|
  #     format.html
  #     format.pdf do
  #       render pdf: 'Pet Medical Report', # file name
  #              template: 'home/pet_report1.html.erb',
  #              layout: 'layouts/pdf.html.erb', # optional, use 'pdf.html' for a simple layout
  #              disposition: 'inline',
  #             margin: { top: 0, bottom: 0, left: 0, right: 0 } # 'attachment' to download, 'inline' to display in the browser
  #     end
  #   end
end
