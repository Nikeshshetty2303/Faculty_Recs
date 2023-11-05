class FileUpload < ApplicationRecord
    has_many_attached :file
    belongs_to :upload_question, optional: true
    accepts_nested_attributes_for :upload_question
end
