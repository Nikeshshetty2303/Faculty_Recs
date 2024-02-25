class ResponsesController < ApplicationController
  before_action :set_response, only: %i[ show edit update destroy]

  # GET /responses or /responses.json
  def index
    @form = Form.find(params[:id])
    @user = User.find(params[:userid])
    @responses = Response.where(form_id: @form.id)
  end

  def myresponse
    @user = User.find(params[:id])
    @responses = Response.where(user_id: @user.id)
  end

  def validate
    @user = User.find(current_user.id)
    @responses = Response.find(params[:id])
  end

  def my_credit
    @response = Response.find(params[:id])
    @user = User.find(params[:userid])
    @section = CreditSection.all
  end

  def display
    @response = Response.find(params[:id])
    @user = User.find(params[:userid])
  end

  def print
    @response = Response.find(params[:id])
    @user = User.find(params[:userid])
    respond_to do |format|
        format.html
        format.pdf do
          render pdf: 'Response Pdf', # file name
                 template: 'responses/displaypdf.html.erb',
                 layout: 'layouts/pdf.html.erb', # optional, use 'pdf.html' for a simple layout
                 disposition: 'inline',
                 locals: { response: @response, user: @user },
                margin: { top: 0, bottom: 0, left: 0, right: 0 } # 'attachment' to download, 'inline' to display in the browser
        end
      end
  end

  def view_pdf
    @answer = CreditAnswer.find(params[:ansid])
    send_data @answer.file_upload.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
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
        if @response.validation == true 
          CreditValidateMailer.with(userid: @user.id).success.deliver_later
        else
          CreditValidateMailer.with(userid: @user.id).failure.deliver_later
        end
        format.html { redirect_to home_validate_url(@response), notice: "Response was successfully updated." }
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
      params.require(:response).permit(:title, :validation)
    end
end
