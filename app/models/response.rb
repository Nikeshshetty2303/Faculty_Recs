require 'combine_pdf'

class Response < ApplicationRecord
  belongs_to :form, optional: true
  has_many :answers, dependent: :destroy
  has_many :credit_answers, dependent: :destroy
  has_many :file_uploads, dependent: :destroy
  belongs_to :user, optional:true
  accepts_nested_attributes_for :answers, allow_destroy: true
  has_one_attached :current_stage, dependent: :destroy
  has_one_attached :summary_pdf, dependent: :destroy
  has_one_attached :combined_pdf, dependent: :destroy


  def combine_and_store_pdfs(response)
    pdf_answers = answers.select { |answer| answer.file.attached? && answer.file.content_type == 'application/pdf' }

    return if pdf_answers.empty?

    combined_pdf = CombinePDF.new

    pdf_answers.each do |answer|
      temp_file = Tempfile.new(['temp_pdf', '.pdf'])
      temp_file.binmode
      temp_file.write(answer.file.download)
      temp_file.close

      combined_pdf << CombinePDF.load(temp_file.path)

      temp_file.unlink
    end

    temp_combined = Tempfile.new(['combined', '.pdf'])
    temp_combined.binmode
    temp_combined.write(combined_pdf.to_pdf)
    temp_combined.close

    response.combined_pdf.attach(
      io: File.open(temp_combined.path),
      filename: "response_#{id}_combined.pdf",
      content_type: 'application/pdf'
    )

    temp_combined.unlink

    response.save!
  end
end
