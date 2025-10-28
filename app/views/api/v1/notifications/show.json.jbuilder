json.extract! @notification,
  :id,
  :title,
  :body,
  :status,
  :priority,
  :from_organization_id,
  :to_organization_id,
  :created_at,
  :updated_at

if @notification.attachment.attached?
  json.attachment do
    json.filename @notification.attachment.filename
    json.url url_for(@notification.attachment)
  end
end
