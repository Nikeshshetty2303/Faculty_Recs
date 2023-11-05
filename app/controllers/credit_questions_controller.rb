class CreditQuestionsController < ApplicationController
  before_action :set_credit_question, only: %i[ show edit update destroy ]

  # GET /credit_questions or /credit_questions.json
  def index
    @credit_questions = CreditQuestion.all
  end

  # GET /credit_questions/1 or /credit_questions/1.json
  def show
  end

  # GET /credit_questions/new
  def new
    @credit_question = CreditQuestion.new
  end

  # GET /credit_questions/1/edit
  def edit
  end

  # POST /credit_questions or /credit_questions.json
  def create
    @credit_question = CreditQuestion.new(credit_question_params)

    respond_to do |format|
      if @credit_question.save
        format.html { redirect_to credit_question_url(@credit_question), notice: "Credit question was successfully created." }
        format.json { render :show, status: :created, location: @credit_question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @credit_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credit_questions/1 or /credit_questions/1.json
  def update
    respond_to do |format|
      if @credit_question.update(credit_question_params)
        format.html { redirect_to credit_question_url(@credit_question), notice: "Credit question was successfully updated." }
        format.json { render :show, status: :ok, location: @credit_question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @credit_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credit_questions/1 or /credit_questions/1.json
  def destroy
    @credit_question.destroy

    respond_to do |format|
      format.html { redirect_to credit_questions_url, notice: "Credit question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_question
      @credit_question = CreditQuestion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def credit_question_params
      params.require(:credit_question).permit(:title, :credit_section_id)
    end
end
