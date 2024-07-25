class CreditAnswersController < ApplicationController
  attr_accessor :remove_file_upload
  before_action :set_credit_answer, only: %i[ show edit update destroy ]

  # GET /credit_answers or /credit_answers.json
  def index
    @credit_answers = CreditAnswer.all
  end

  # GET /credit_answers/1 or /credit_answers/1.json
  def show
  end

  # GET /credit_answers/new
  def new
    puts "Reached the new action"
    @form = Form.find(params[:id])
    @user = User.find(params[:userid])
    @section = CreditSection.all
    @questions = CreditQuestion.all
    @answers = @questions.map { |question| CreditAnswer.new(credit_question_id: question.id) }
  end

  # GET /credit_answers/1/edit
  def edit
  end

  # POST /credit_answers or /credit_answers.json
  def create
    @questions = CreditQuestion.all
    answer_params_array = params[:answers][:answers]

    response = Response.create!

    parameter_value = params[:answers][:entry]
    response.form_id = parameter_value

    @answers = []
    section_credits = Hash.new(0)

    answer_params_array.each do |_, answer_param|
      permitted_params = answer_param.permit(:answer, :credit_question_id, :response_id, :is_upload, :credit_section_id, :file_upload)
      answer = CreditAnswer.new(permitted_params)
      answer.answer = 0 if answer.answer.nil?

      if permitted_params[:file_upload].present?
        answer.file_upload.attach(permitted_params[:file_upload])
      end

      credit_per_answer = answer.credit_question.obt_credit * answer.answer

      answer.response_id = response.id
      answer.credit = credit_per_answer
      answer.verified_count = answer.answer
      answer.verified_credit = credit_per_answer

      section_credits[answer.credit_section_id] += credit_per_answer
      @answers << answer
    end

    total_credit = 0
    section_credits.each do |section_id, section_credit|
      section = CreditSection.find(section_id)
      if section.max_credit.present? && section.max_credit > 0
        capped_section_credit = [section_credit, section.max_credit].min
        total_credit += capped_section_credit
      else
        total_credit += section_credit
      end
    end

    response.credit_score = total_credit
    response.user_id = current_user.id
    response.title = current_user.email
    form_id = response.form_id
    @form = Form.find(form_id)


      response.save
      if @answers.all? { |answer| answer.valid? }
        @answers.each(&:save)
        redirect_to submit_form_form_path(id: response.id, userid: current_user.id, form_id: @form.id), notice: 'Answers were successfully created.'
      else
        render :new
      end
  end

  def update_batch
    updates = params[:credit_answers]
    response_id = params[:response_id]
    validated_credit_score = params[:validated_credit_score]

    ActiveRecord::Base.transaction do
      updates.each do |update|
        credit_answer = CreditAnswer.find(update[:id])
        credit_answer.update!(
          verified_count: update[:verified_count],
          verified_credit: update[:verified_credit]
        )
      end

      response = Response.find(response_id)
      response.update!(validated_credit_score: validated_credit_score)
    end

    render json: { success: true }
  rescue ActiveRecord::RecordInvalid => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  def update_response
  @questions = CreditQuestion.all
  answer_params_array = params[:answers][:answers]

  response = Response.find(params[:res_id])

  @answers = []
  section_credits = Hash.new(0)

  answer_params_array.each do |answer_param|
    permitted_params = answer_param[1].permit(:answer, :credit_question_id, :response_id, :is_upload, :credit_section_id, :file_upload, :remove_file_upload)
    answer = CreditAnswer.find(answer_param.first)

    answer.answer = permitted_params[:answer]

    answer.answer = 0 if answer.answer.nil?

    # Handle file upload and removal
    if permitted_params[:remove_file_upload] == '1'
      answer.file_upload.purge if answer.file_upload.attached?
    elsif permitted_params[:file_upload].present?
      answer.file_upload.attach(permitted_params[:file_upload])
    end

    credit_per_answer = answer.credit_question.obt_credit * answer.answer

      answer.response_id = response.id
      answer.credit = credit_per_answer
      answer.verified_count = answer.answer
      answer.verified_credit = credit_per_answer

      section_credits[answer.credit_section_id] += credit_per_answer
      @answers << answer
  end

  total_credit = 0
    section_credits.each do |section_id, section_credit|
      section = CreditSection.find(section_id)
      if section.max_credit.present? && section.max_credit > 0
        capped_section_credit = [section_credit, section.max_credit].min
        total_credit += capped_section_credit
      else
        total_credit += section_credit
      end
    end

    response.credit_score = total_credit
    response.user_id = current_user.id
    response.title = current_user.email
    form_id = response.form_id
    @form = Form.find(form_id)

    response.save
    if @answers.all? { |answer| answer.valid? }
      @answers.each(&:save)
      redirect_to my_credit_response_path(id: response.id, userid: current_user.id), notice: 'Answers were successfully created.'
    else
      render :new
    end
end
  # PATCH/PUT /credit_answers/1 or /credit_answers/1.json
  def update
    response = Response.find_by(id: @credit_answer.response_id)
    respond_to do |format|
      if @credit_answer.update(credit_answer_params)

        answer_credit=0
        response.credit_answers.each do |answer|
          answer_credit = answer_credit + answer.verified_credit
        end
        response.credit_score = answer_credit.round(2)
        response.validation = true
        response.save

        format.html { redirect_to validate_response_path(id: @credit_answer.response_id), notice: "Credit answer was successfully updated." }
        format.json { render :show, status: :ok, location: @credit_answer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @credit_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credit_answers/1 or /credit_answers/1.json
  def destroy
    @credit_answer.destroy

    respond_to do |format|
      format.html { redirect_to credit_answers_url, notice: "Credit answer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_answer
      @credit_answer = CreditAnswer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def credit_answer_params
      params.require(:credit_answer).permit(:answer, :credit_question_id, :entry, :credit, :verified_count, :verified_credit, :response_id, :file_upload, :is_upload, :credit_section_id, :remove_file_upload)
    end
end
