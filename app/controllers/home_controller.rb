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
    @credit_questions = CreditQuestion.where(isheader: nil)

    @responses = Response.joins(form: :department)
                     .where(form: { departments: { title: current_user.validator } }, status: "Freezed")
                     .includes(credit_answers: :credit_question).sort_by { |response| response.app_no.to_s.strip }
    # Create a new Excel package
    package = Axlsx::Package.new
    workbook = package.workbook

    # Add a worksheet to the package
    workbook.add_worksheet(name: "YourModel Data") do |sheet|
      styles = create_styles(workbook)
      # Add the first header row with the application ID
      headers = ["Application ID"] + @credit_questions.map(&:title).flat_map { |title| [title, "", "", ""] } +
      [
        "Undergraduate", "Postgraduate", "PhD", "PostDoc",
        "Experience Type/Institute Ranking", "Major Awards / Fellowship",
        "Academic Credentials", "Academic Credentials Comments",
        "Professional Experience", "Professional Experience Comments",
        "Credit Requirements", "Credit Requirements Comments",
        "Eligibility", "Remark"
      ]
      sheet.add_row headers, style: styles[:header]

      # Merge the cells for each question's sub-columns in the first header row
      @credit_questions.each_with_index do |question, index|
        start_column = index * 4 + 1  # Each question has 4 sub-columns, starting after the Application ID
        end_column = start_column + 3
        range = "#{Axlsx::col_ref(start_column)}1:#{Axlsx::col_ref(end_column)}1"
        sheet.merge_cells(range)
      end

      # Add the second header row with the sub-column names
      sub_headers = [""] + @credit_questions.flat_map { ["Count", "Verified Count", "Credit", "Verified Credit"] }
      sheet.add_row sub_headers, style: styles[:sub_header]

      # Add data rows
      @responses.each do |response|
        row_data = [response.app_no] + @credit_questions.flat_map do |question|
          answer = response.credit_answers.find { |a| a.credit_question_id == question.id }
          if answer.present?
            [answer.answer, answer.verified_count, answer.credit, answer.verified_credit]
          else
            ["", "", "", ""]
          end
        end
        row_data += [
          response.undergraduate,
          response.postgraduate,
          response.phd,
          response.postdoc,
          response.experience_type,
          response.major_awards,
          response.academic_experience ? "Satisfactory" : "Not Satisfactory",
          response.acad_exp_comments,
          response.professional_experience ? "Satisfactory" : "Not Satisfactory",
          response.prof_exp_comments,
          response.credit_requirements ? "Satisfactory" : "Not Satisfactory",
          response.credit_req_comments,
          response.eligibility ? "Yes" : "No",
          response.remark
        ]

        row_style = styles[:even_row]
        sheet.add_row row_data, style: row_style, types: [:string] * row_data.length
      end
    end

    # Send the Excel file as a response
    send_data package.to_stream.read, type: "application/xlsx", filename: "Credit_data_#{current_user.validator}.xlsx"
  end

  def create_styles(workbook)
    {
      header: workbook.styles.add_style(
        bg_color: "4F81BD",
        fg_color: "FFFFFF",
        b: true,
        alignment: { horizontal: :center, vertical: :center, wrap_text: true }
      ),
      sub_header: workbook.styles.add_style(
        bg_color: "D0D8E8",
        b: true,
        alignment: { horizontal: :center, vertical: :center, wrap_text: true }
      ),
      even_row: workbook.styles.add_style(
        bg_color: "E9EDF4",
        alignment: { horizontal: :left, vertical: :center, wrap_text: true }
      ),
      odd_row: workbook.styles.add_style(
        bg_color: "FFFFFF",
        alignment: { horizontal: :left, vertical: :center, wrap_text: true }
      )
    }
  end

  # respond_to do |format|
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
