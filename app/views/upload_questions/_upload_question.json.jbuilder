json.extract! upload_question, :id, :title, :upload_section_id, :created_at, :updated_at
json.url upload_question_url(upload_question, format: :json)
