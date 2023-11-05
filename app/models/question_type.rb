class QuestionType < ApplicationRecord
  has_many :question, dependent: :destroy
end
