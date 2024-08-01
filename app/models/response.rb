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
    skipped_pdfs = []

    pdf_answers.each do |answer|
      begin
        temp_file = Tempfile.new(['temp_pdf', '.pdf'])
        temp_file.binmode
        temp_file.write(answer.file.download)
        temp_file.close

        pdf = CombinePDF.load(temp_file.path)
        combined_pdf << pdf
      rescue StandardError => e
        Rails.logger.warn "Skipping PDF for answer #{answer.id} (Question: #{answer.question.title}) due to error: #{e.message}"
        skipped_pdfs << answer.question.title
      ensure
        temp_file.unlink if temp_file
      end
    end

    if combined_pdf.pages.empty?
      Rails.logger.warn "No PDFs were successfully combined for response #{response.id}"
      response.update(skipped: skipped_pdfs) if skipped_pdfs.any?
      return
    end

    temp_combined = Tempfile.new(['combined', '.pdf'])
    temp_combined.binmode
    temp_combined.write(combined_pdf.to_pdf)
    temp_combined.close

    response.combined_pdf.attach(
      io: File.open(temp_combined.path),
      filename: "response_#{response.id}_combined.pdf",
      content_type: 'application/pdf'
    )

    temp_combined.unlink

    # Only update skipped if there are actually skipped PDFs
    if skipped_pdfs.any?
      response.skipped = skipped_pdfs
      response.save!
      Rails.logger.info "Combined PDFs for response #{response.id}, but skipped problematic PDFs for questions: #{skipped_pdfs.join(', ')}"
    else
      response.skipped = nil
      response.save!
      Rails.logger.info "Successfully combined all PDFs for response #{response.id}"
    end
  rescue StandardError => e
    Rails.logger.error "Failed to combine and store PDFs for response #{response.id}: #{e.message}"
    response.update(skipped: skipped_pdfs) if skipped_pdfs.any?
    # Handle the error appropriately (e.g., set an error flag on the response)
  end
end
