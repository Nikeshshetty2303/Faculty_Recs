class FormsController < ApplicationController
  before_action :set_form, only: %i[ show edit update destroy ]

  def submit_form
    @form = Form.find(params[:form_id])
    @response = Response.find(params[:id])
    @questions = @form.questions
    @user = User.find(params[:userid])
  end

  def view_pdf
    @answer = Answer.find(params[:ansid])
    send_data @answer.file.download, filename: "document.pdf", type: "application/pdf", disposition: "inline"
  end

def create_response
  @user = User.find(current_user.id)
  if @user.tab_no !=1
    @response = @user.responses.where(profile_response: true).last
  else
    @response = Response.new
    @response.profile_response = true
  end
  @questions = Question.where(tab_id: @user.tab_no)
  present_tab_no = @user.tab_no
  @user.tab_no = present_tab_no +1
  @user.nav_tab_no = @user.tab_no
  @user.save
  answers_attributes = params.dig(:response, :answers_attributes)
  @response.user_id = current_user.id
  if answers_attributes.present?
    answers_attributes.each do |question_id, answer_data|
      question = @questions.find_by(id: question_id)
      next unless question
      content = answer_data[:content]
      if question.question_type_id == 3
        # If content is an array, store it as is, otherwise convert it to an array
        content = content.is_a?(Array) ? content : [content].compact
      end

      if question.question_type_id == 9
        if answer_data[:file].present?
          file = answer_data[:file]
        end
      end
      @response.answers.build(question: question, content: content, file: file)
    end
  end

  if @response.save
    if @user.tab_no > Tab.count
      @user.nav_tab_no = 1
      @user.tab_no = Tab.count + 1
      @user.save
      redirect_to home_index_path(id: @user.id), notice: 'Form submitted successfully.'
    else
      redirect_to home_app_profile_path(id: @user.id, res_id: @response.id, nav_tab_no: @user.nav_tab_no), notice: 'Form submitted successfully.'
    end
  else
    # If there are validation errors, re-render the form with errors.
    @questions = @form.questions.includes(:options)  # Ensure questions are preloaded with options to avoid N+1 query.
    render 'forms/show'  # Assuming you have a show template to render the form.
  end
end

def update_app_profile_response
  @user = User.find(current_user.id)
  @response = Response.find(params[:res_id])
  @questions = Question.where(tab_id: @user.nav_tab_no)
  present_tab_no = @user.nav_tab_no
  @user.nav_tab_no = present_tab_no +1
  if  @user.nav_tab_no > @user.tab_no
      @user.nav_tab_no = @user.tab_no
  end
  @user.save
  answers_attributes = params.dig(:response, :answers_attributes)
  if answers_attributes.present?
    answers_attributes.each do |question_id, answer_data|
      question = @questions.find_by(id: question_id)
      next unless question
      content = answer_data[:content]
      if question.question_type_id == 3
        # If content is an array, store it as is, otherwise convert it to an array
        content = content.is_a?(Array) ? content : [content].compact
      end

      answer = @response.answers.find_by(question: question)
      if question.question_type_id == 9
        if answer_data[:remove_file] == '1'
          answer.file.purge if answer && answer.file.attached?
          file = nil
        elsif answer_data[:file].present?
          file = answer_data[:file]
        end
      end
      if answer
        answer.update(content: content)
        answer.file.attach(file) if file
      else
        @response.answers.build(question: question, content: content, file: file)
      end
    end
  end



  if @response.save
    if @user.tab_no > Tab.count
      @user.nav_tab_no = 1
      @user.tab_no = 9
      @user.save
      redirect_to home_index_path(id: @user.id), notice: 'Form submitted successfully.'
    else
      redirect_to home_app_profile_path(id: @user.id, res_id: @response.id, nav_tab_no: @user.nav_tab_no), notice: 'Form submitted successfully.'
    end
  else
    # If there are validation errors, re-render the form with errors.
    @questions = @form.questions.includes(:options)  # Ensure questions are preloaded with options to avoid N+1 query.
    render 'forms/show'  # Assuming you have a show template to render the form.
  end
end

def update_response
  @form = Form.find(params[:form_id])
  @response = Response.find(params[:id])
  @questions = @form.questions
  answers_attributes = params.dig(:response, :answers_attributes)
  if answers_attributes.present?
    answers_attributes.each do |question_id, answer_data|
      question = @questions.find_by(id: question_id)
      next unless question
      content = answer_data[:content]

      if question.question_type_id == 3
        # Ensure content is an array

        content = content.reject(&:empty?) if content.is_a?(Array)
        content = content.present? ? content : nil
      end

      # if question.question_type_id == 6
      #   # Ensure content is always an array
      #   content = Array(content).reject(&:empty?)
      # else
      #   # For other question types, ensure content is stored as an array with a single element
      #   content = [content].reject(&:empty?)
      # end

      if question.question_type_id == 9
        if answer_data[:file].present?
          file = answer_data[:file]
        end
      end

      if @response.answers.find_by(question: question)
        @response.answers.where(question: question).update(content: content, file: file)
      else
        @response.answers.build(question: question, content: content, file: file)
      end
    end
  end

  present_response_id = @response.id
  below_responses = Response.where(profile_response: true).where("id < ?", present_response_id)
  count_below_responses = below_responses.count
  role = @response.form.role
  dept = @response.form.department.title

  @response.app_no = "#{role}#{dept}#{1000 + @response.id - count_below_responses}"

  if @response.save
    redirect_to display_response_path(id: @response.id, userid: current_user.id), notice: 'Form submitted successfully.'
  else
    # If there are validation errors, re-render the form with errors.
    @questions = @form.questions.includes(:options)
    render 'forms/show'
  end
end


  def checkout
    @response = Response.find(params[:id])
    form_id = @response.form_id
    @form = Form.find(form_id)
    @user = User.find(params[:userid])
  end


  def payment
    @response = Response.find(params[:id])
    @form = Form.find(params[:form_id])
    @response.update(amount: @form.fee, payment_status: true)
    if(@response.payment_status == true)
      PaymentMailer.with(user_id: current_user.id, response_id: @response.id, form_id: @form.id).payment.deliver_later
    end
    redirect_to home_index_path
  end


  # GET /forms or /forms.json
  def index
    @user = User.find(params[:userid])
    @forms = Form.where(user_id: @user.id)
  end

  # GET /forms/1 or /forms/1.json
  def show
    @user = User.find(params[:userid])
  end

  # GET /forms/new
  def new
    @user = User.find(params[:userid])
    @form = Form.new
  end

  # GET /forms/1/edit
  def edit
  end

  # POST /forms or /forms.json
  def create
    @form = Form.new(form_params)
    @form.user_id = params[:form][:user_id]
    respond_to do |format|
      if @form.save
        if template_form_id.present?
          template_form = Form.find_by(id: template_form_id)
          if template_form
            template_form.questions.each do |template_question|
              new_question = @form.questions.create(title: template_question.title, question_type_id: template_question.question_type_id)
              template_question.options.each do |template_option|
                new_question.options.create(title: template_option.title)
              end
            end
          end
        end
        format.html { redirect_to form_url( @form, userid: @form.user_id ), notice: "Form was successfully created." }
        format.json { render :show, status: :created, location: @form }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /forms/1 or /forms/1.json
  def update
    respond_to do |format|
      if @form.update(form_params)
        format.html { redirect_to form_url(@form), notice: "Form was successfully updated." }
        format.json { render :show, status: :ok, location: @form }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forms/1 or /forms/1.json
  def destroy
    @user_id =@form.user_id
    @form.destroy

    respond_to do |format|
      format.html { redirect_to home_index_path(userid: @user_id), notice: "Form was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_form
    @form = Form.find(params[:id])
  end

  def form_params
    params.require(:form).permit(:name, :role, :salary, :dept, :template_form_id, :user_id, :fee, :credit_req, :department_id)
  end

  def template_form_id
    params[:form][:template_form_id]
  end

  def response_params
  params.require(:response).permit(answers_attributes: [:id, :question_id, :content, :file])
  end

end
