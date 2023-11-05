class UploadQuestion < ApplicationRecord
  belongs_to :upload_section, optional: true
end
