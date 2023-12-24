class CreditAnswer < ApplicationRecord
  has_one_attached :file_upload, dependent: :destroy
  belongs_to :credit_question, optional: true
  belongs_to :response, optional: true
  belongs_to :credit_section, optional: true
  accepts_nested_attributes_for :credit_question
end
