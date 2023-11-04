json.extract! response, :id, :title, :created_at, :updated_at
json.url response_url(response, format: :json)
