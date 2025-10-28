json.array! @notifications do |notification|
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

  # BUG : N+1 query - accès aux associations sans includes
  json.from_organization_name notification.from_organization.name
  json.to_organization_name notification.to_organization.name
end
