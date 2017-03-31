json.extract! message, :id, :recipient_id, :sender_id, :text, :created_at, :updated_at
json.url message_url(message, format: :json)