class ResponsesController < ApplicationController
  before_action :set_response, only: %i[ show edit update destroy]

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
      # Add the first header row with the application ID
      headers = ["Application ID"] + @credit_questions.map(&:title).flat_map { |title| [title, "", "", ""] }
      sheet.add_row headers

      # Merge the cells for each question's sub-columns in the first header row
      @credit_questions.each_with_index do |question, index|
        start_column = index * 4 + 1  # Each question has 4 sub-columns, starting after the Application ID
        end_column = start_column + 3
        range = "#{Axlsx::col_ref(start_column)}1:#{Axlsx::col_ref(end_column)}1"
        sheet.merge_cells(range)
      end

      # Add the second header row with the sub-column names
      sub_headers = [""] + @credit_questions.flat_map { ["Count", "Verified Count", "Credit", "Verified Credit"] }
      sheet.add_row sub_headers

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
        sheet.add_row row_data
      end
    end

    # Send the Excel file as a response
    send_data package.to_stream.read, type: "application/xlsx", filename: "your_model_data.xlsx"
  end





  # GET /responses or /responses.json
  def index
    @form = Form.find(params[:id])
    @user = User.find(params[:userid])
    @responses = Response.where(form_id: @form.id)
  end

  def myresponse
    @user = User.find(current_user.id)
    @responses = Response.where(user_id: @user.id)
  end

  def validate
    @user = User.find(current_user.id)
    @responses = Response.find(params[:id])
    @res_user = @responses.user
    if @res_user.photo.attached?
      @user_photo_base64 = Base64.strict_encode64(@res_user.photo.download)
    else
      @user_photo_base64 = nil
    end
  end

  def my_credit
    @response = Response.find(params[:id])
    if @response.status == "Freezed"
      redirect_to myresponse_response_path
    end
    @user = User.find(current_user.id)
    @section = CreditSection.all
    @questions = CreditQuestion.all
    form_id = @response.form_id
    @form = Form.find(form_id)
  end

  def my_credit_freezed
    @response = Response.find(params[:id])
    @user = User.find(current_user.id)
    @section = CreditSection.all
    @questions = CreditQuestion.all
    form_id = @response.form_id
    @form = Form.find(form_id)
  end

  def update_status
      @response = Response.find(params[:id])
      @user = User.find(current_user.id)
      @app_response = Response.where(user_id: current_user.id, profile_response: true).last
      if @response.status == "Free"
        @response.status = "Freezed"
        @user.nav_tab_no = 8

        @app_response.combine_and_store_pdfs(@response)

        if @user.photo.attached?
          @user_photo_base64 = Base64.strict_encode64(@user.photo.download)
        else
          @user_photo_base64 = nil
        end

        if @user.sign.attached?
          @user_sign_base64 = Base64.strict_encode64(@user.sign.download)
        else
          @user_sign_base64 = nil
        end

        # Generate PDF
        pdf = WickedPdf.new.pdf_from_string(
          render_to_string(
            template: 'responses/displaypdf.html.erb',
            layout: 'layouts/pdf.html.erb',
            locals: {
              response: @response,
              user: @user,
              app_response: Response.where(user_id: current_user.id, profile_response: true).last
            }
          ),
          margin: { top: 0, bottom: 0, left: 0, right: 0 }
        )

        # Attach the generated PDF to current_stage
        @response.current_stage.attach(
          io: StringIO.new(pdf),
          filename: "response_#{@response.id}.pdf",
          content_type: 'application/pdf'
        )


        # Generate PDF
        sum_pdf = WickedPdf.new.pdf_from_string(
          render_to_string(
            template: 'admin_dashboard/summarypdf.html.erb',
            layout: 'layouts/pdf.html.erb',
            locals: {
              response: @response,
              user: @user,
              app_response: Response.where(user_id: current_user.id, profile_response: true).last
            }
          ),
          margin: { top: 0, bottom: 0, left: 0, right: 0 }
        )

        # Attach the generated PDF to current_stage
        @response.summary_pdf.attach(
          io: StringIO.new(sum_pdf),
          filename: "response_#{@response.id}_summary.pdf",
          content_type: 'application/pdf'
        )

      elsif @response.status == "Freezed"
        @response.status = "Free"
      end

      @response.save
      @user.save
      redirect_to myresponse_response_path
  end

  def combine_pdf
    @response = Response.find(params[:id])
    @user = User.find(current_user.id)
    @app_response = Response.where(user_id: current_user.id, profile_response: true).last
    @app_response.combine_and_store_pdfs(@response)
    if @response.skipped.present?
      redirect_to myresponse_response_path
    else
      send_data @response.combined_pdf.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
    end
  end

  def view_app_pdf
    @response = Response.find(params[:id])
    send_data @response.current_stage.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
  end

  def view_sum_pdf
    @response = Response.find(params[:id])
    send_data @response.summary_pdf.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
  end

  def view_combined_pdf
    @response = Response.find(params[:id])
    send_data @response.combined_pdf.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
  end


  def display
    @response = Response.find(params[:id])
    @user = User.find(current_user.id)
    form_id = @response.form_id
    @form = Form.find(form_id)
    @questions = Question.where(form_id: form_id)
    @app_response = Response.where(user_id: current_user.id, profile_response: true).last
  end

  def print
    @response = Response.find(params[:id])
    @user = User.find(params[:userid])
    @app_response = Response.where(user_id: @user.id, profile_response: true).last
    if @user.photo.attached?
      @user_photo_base64 = Base64.strict_encode64(@user.photo.download)
    else
      @user_photo_base64 = nil
    end

    if @user.sign.attached?
      @user_sign_base64 = Base64.strict_encode64(@user.sign.download)
    else
      @user_sign_base64 = nil
    end

    respond_to do |format|
        format.html
        format.pdf do
          render pdf: 'Response Pdf', # file name
                 template: 'responses/displaypdf.html.erb',
                 layout: 'layouts/pdf.html.erb', # optional, use 'pdf.html' for a simple layout
                 disposition: 'inline',
                 locals: { response: @response, user: @user, app_response: @app_response},
                margin: { top: 0, bottom: 0, left: 0, right: 0 } # 'attachment' to download, 'inline' to display in the browser
        end
      end
  end

  def print_profile
    @app_response = Response.find(params[:id])
    @user = User.find(params[:userid])
    if @user.photo.attached?
      @user_photo_base64 = Base64.strict_encode64(@user.photo.download)
    else
      @user_photo_base64 = nil
    end

    if @user.sign.attached?
      @user_sign_base64 = Base64.strict_encode64(@user.sign.download)
    else
      @user_sign_base64 = nil
    end

    respond_to do |format|
        format.html
        format.pdf do
          render pdf: 'Response Pdf', # file name
                 template: 'admin_dashboard/profilepdf.html.erb',
                 layout: 'layouts/pdf.html.erb', # optional, use 'pdf.html' for a simple layout
                 disposition: 'inline',
                 locals: { response: @response, user: @user, app_response: @app_response},
                margin: { top: 0, bottom: 0, left: 0, right: 0 } # 'attachment' to download, 'inline' to display in the browser
        end
      end
  end

  def view_pdf
    @answer = CreditAnswer.find(params[:ansid])
    send_data @answer.file_upload.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
  end

  def add_remark
    @response = Response.find(params[:res_id])
    @response.update(response_params)
    if @response.update(response_params)
      redirect_to validate_response_path(id: @response.id), notice: 'Form submitted successfully.'
    else
      render 'forms/show'
    end
  end

  def update_eligibility
    @response = Response.find(params[:res_id])
    @response.update(response_params)
    if @response.update(response_params)
      redirect_to validate_response_path(id: @response.id), notice: 'Form submitted successfully.'
    else
      render 'forms/show'
    end
  end

  # GET /responses/1 or /responses/1.json
  def show
  end

  # GET /responses/new
  def new
    @response = Response.new
  end

  # GET /responses/1/edit
  def edit
  end

  # POST /responses or /responses.json
  def create
    @response = Response.new(response_params)

    respond_to do |format|
      if @response.save
        format.html { redirect_to response_url(@response), notice: "Response was successfully created." }
        format.json { render :show, status: :created, location: @response }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responses/1 or /responses/1.json
  def update
    @user = @response.user
    respond_to do |format|
      if @response.update(response_params)
        format.html { redirect_to validate_response_path(@response), notice: "Response was successfully updated." }
        format.json { render :show, status: :ok, location: @response }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /responses/1 or /responses/1.json
  def destroy
    @response.destroy

    respond_to do |format|
      format.html { redirect_to responses_url, notice: "Response was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Response.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def response_params
      params.require(:response).permit(:title, :validation,:new_count, :remark, :eligibility, :current_stage, :validated_credit_score, :summary_pdf, :combined_pdf, :skipped, :app_no, :academic_experience, :professional_experience, :credit_requirements, :undergraduate, :postgraduate, :phd,:postdoc,:experience_type, :major_awards, :acad_exp_comments, :prof_exp_comments, :credit_req_comments)
    end
end
