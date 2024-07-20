class Form < ApplicationRecord
  has_many :questions, -> { order(position: :asc) }, dependent: :destroy
  has_many :responses, dependent: :destroy
  belongs_to :user
  belongs_to :department, optional:true

  def apply_template(template_form_id)
    template_form = Form.find_by(id: template_form_id)
    if template_form
      template_form.questions.each do |template_question|
        new_question = questions.create(title: template_question.title, question_type_id: template_question.question_type_id)
        template_question.options.each do |template_option|
          new_question.options.create(title: template_option.title)
        end
      end
    end
  end
end
