class FileUploadsController < ApplicationController
  before_action :set_file_upload, only: %i[ show edit update destroy ]

  # GET /file_uploads or /file_uploads.json
  def index
    @file_uploads = FileUpload.all
  end

  # GET /file_uploads/1 or /file_uploads/1.json
  def show
  end

  # GET /file_uploads/new
  def new
    @file_upload = FileUpload.new
    @user = User.find(params[:userid])
  end

  # GET /file_uploads/1/edit
  def edit
  end

  # POST /file_uploads or /file_uploads.json
  def create
    file_params_array = params[:files][:files]
    @files = []
    responses = Response.where(user_id: current_user.id)
    response = responses.last

    file_params_array.each do |file_param|
      permitted_params = file_param.permit(:file)
      file = FileUpload.new(permitted_params)
      @files << file
    end

    response.update(credit_score: 0)
    response.save!

    if @files.all? { |file| file.valid? }
      @files.each(&:save)
      redirect_to submit_form_form_path(userid: current_user.id,id: form.id), notice: 'Files were successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /file_uploads/1 or /file_uploads/1.json
  def update
    respond_to do |format|
      if @file_upload.update(file_upload_params)
        format.html { redirect_to file_upload_url(@file_upload), notice: "File upload was successfully updated." }
        format.json { render :show, status: :ok, location: @file_upload }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @file_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /file_uploads/1 or /file_uploads/1.json
  def destroy
    @file_upload.destroy

    respond_to do |format|
      format.html { redirect_to file_uploads_url, notice: "File upload was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_file_upload
      @file_upload = FileUpload.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def file_upload_params
      params.require(:file_upload).permit(:file)
    end
end
