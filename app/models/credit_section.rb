class CreditSection < ApplicationRecord
    has_many :credit_questions, dependent: :destroy
    has_many :credit_answers, dependent: :destroy
end
