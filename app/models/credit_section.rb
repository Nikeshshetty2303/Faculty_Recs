class CreditSection < ApplicationRecord
    has_many :credit_questions, dependent: :destroy
end
