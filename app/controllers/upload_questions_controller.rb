class UploadQuestionsController < ApplicationController
  before_action :set_upload_question, only: %i[ show edit update destroy ]

  # GET /upload_questions or /upload_questions.json
  def index
    @upload_questions = UploadQuestion.all
  end

  # GET /upload_questions/1 or /upload_questions/1.json
  def show
  end

  # GET /upload_questions/new
  def new
    @upload_question = UploadQuestion.new
  end

  # GET /upload_questions/1/edit
  def edit
  end

  # POST /upload_questions or /upload_questions.json
  def create
    @upload_question = UploadQuestion.new(upload_question_params)

    respond_to do |format|
      if @upload_question.save
        format.html { redirect_to upload_question_url(@upload_question), notice: "Upload question was successfully created." }
        format.json { render :show, status: :created, location: @upload_question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @upload_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /upload_questions/1 or /upload_questions/1.json
  def update
    respond_to do |format|
      if @upload_question.update(upload_question_params)
        format.html { redirect_to upload_question_url(@upload_question), notice: "Upload question was successfully updated." }
        format.json { render :show, status: :ok, location: @upload_question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @upload_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /upload_questions/1 or /upload_questions/1.json
  def destroy
    @upload_question.destroy

    respond_to do |format|
      format.html { redirect_to upload_questions_url, notice: "Upload question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload_question
      @upload_question = UploadQuestion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def upload_question_params
      params.require(:upload_question).permit(:title, :upload_section_id)
    end
end
