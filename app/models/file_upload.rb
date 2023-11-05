class FileUpload < ApplicationRecord
    has_many_attached :file
end
