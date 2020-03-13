json.extract! weekly, :id, :title, :issue, :published_at, :created_at, :updated_at
json.pdf rails_blob_path(weekly.pdf) if weekly.pdf.attached?
json.url weekly_url(weekly, format: :json)
