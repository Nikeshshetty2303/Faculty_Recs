class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :response
  has_one_attached :file
end
