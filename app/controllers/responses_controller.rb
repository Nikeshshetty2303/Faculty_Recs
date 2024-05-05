class ResponsesController < ApplicationController
  before_action :set_response, only: %i[ show edit update destroy]

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
  end

  def my_credit
    @response = Response.find(params[:id])
    @user = User.find(current_user.id)
    @section = CreditSection.all
    @questions = CreditQuestion.all
    form_id = @response.form_id
    @form = Form.find(form_id)
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
    @app_response = Response.where(user_id: current_user.id, profile_response: true).last
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
      params.require(:response).permit(:title, :validation,:new_count, :remark, :eligibility)
    end
end
