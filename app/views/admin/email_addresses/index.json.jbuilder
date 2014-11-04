json.array!(@admin_email_addresses) do |admin_email_address|
  json.extract! admin_email_address, :id, :email
  json.url admin_email_address_url(admin_email_address, format: :json)
end
