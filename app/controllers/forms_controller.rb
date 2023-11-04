class FormsController < ApplicationController
  before_action :set_form, only: %i[ show edit update destroy ]

  def submit_form
    @form = Form.find(params[:id])
    @questions = @form.questions

    # render :submit_form
  end

def create_response
  @form = Form.find(params[:id])
  @response = Response.new
  @questions = @form.questions
  answers_attributes = params.dig(:response, :answers_attributes)
  @response.user_id = @form.user_id
  if answers_attributes.present?
    answers_attributes.each do |question_id, answer_data|
      question = @questions.find_by(id: question_id)
      next unless question
      content = answer_data[:content]
      if question.question_type_id == 3
       # If content is an array, store it as is, otherwise convert it to an array
       content = content.is_a?(Array) ? content : [content].compact
       redirect_to forms_path
     end
      @response.answers.build(question: question, content: content)
    end
  end

  if @response.save
    redirect_to home_index_path, notice: 'Form submitted successfully.'
  else
    # If there are validation errors, re-render the form with errors.
    @questions = @form.questions.includes(:options)  # Ensure questions are preloaded with options to avoid N+1 query.
    render 'forms/show'  # Assuming you have a show template to render the form.
  end
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
    @form.destroy

    respond_to do |format|
      format.html { redirect_to forms_url, notice: "Form was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_form
    @form = Form.find(params[:id])
  end

  def form_params
    params.require(:form).permit(:name, :role, :salary, :dept, :template_form_id, :user_id)
  end

  def template_form_id
    params[:form][:template_form_id]
  end

  def response_params
  params.require(:response).permit(answers_attributes: [:id, :question_id, :content])
  end

end
