json.extract! gallery, :id, :user_id, :name, :state, :image_prompt, :send_request_on_save, :created_at, :updated_at
json.url gallery_url(gallery, format: :json)
