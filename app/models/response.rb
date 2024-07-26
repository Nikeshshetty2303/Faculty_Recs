class Response < ApplicationRecord
  belongs_to :form, optional: true
  has_many :answers, dependent: :destroy
  has_many :credit_answers, dependent: :destroy
  has_many :file_uploads, dependent: :destroy
  belongs_to :user, optional:true
  accepts_nested_attributes_for :answers, allow_destroy: true
  has_one_attached :current_stage, dependent: :destroy
  has_one_attached :summary_pdf, dependent: :destroy
end
