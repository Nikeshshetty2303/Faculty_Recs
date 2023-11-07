class QuestionsController < ApplicationController
  before_action :set_question, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:edit]
  skip_before_action :verify_authenticity_token
  # GET /questions or /questions.json
  def index
    @questions = Question.all
  end

  def moveup
    @question = Question.find(params[:id])
    @form =Form.find(  @question.form_id )
    @question.move_higher
    redirect_to form_url(@question.form_id,userid:@form.user_id)
  end

  def movedown
    @question = Question.find(params[:id])
    @form =Form.find(  @question.form_id )
    @question.move_lower
    redirect_to form_url(@question.form_id,userid:@form.user_id)
  end
  # GET /questions/1 or /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @id = params[:form_id]
    @question = Question.new
    @question.form_id = @id
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
    respond_to do |format|
       format.js { render layout: false, content_type: 'text/javascript' }
    end
  end

  # POST /questions or /questions.json
  def create
    @question = Question.new(question_params)
    @question.form_id = params[:question][:form_id]
    @form =Form.find(  @question.form_id )
    respond_to do |format|
      if @question.save
        format.html { redirect_to form_url(@question.form_id,userid:@form.user_id), notice: "Question was successfully created." }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    respond_to do |format|

      @form = Form.find(@question.form_id)
      if @question.update(question_params)
        format.html { redirect_to form_url(@question.form_id, userid:@form.user_id), notice: "Question was successfully updated." }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @form = Form.find(@question.form_id)
    @question.options.destroy_all
    @question.destroy

    respond_to do |format|
      format.html { redirect_to form_url(@form.id, userid:@form.user_id), notice: "Question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:title, :form_id, :position, :question_type_id, options_attributes: [:title])
    end
end
