json.extract! notification,
  :id,
  :title,
  :body,
  :status,
  :priority,
  :from_organization_id,
  :to_organization_id,
  :created_at,
  :updated_at

json.from_organization_name notification.from_organization.name
json.to_organization_name notification.to_organization.name

if notification.attachment.attached?
  json.attachment do
    json.filename notification.attachment.filename
    json.url url_for(notification.attachment)
  end
end
