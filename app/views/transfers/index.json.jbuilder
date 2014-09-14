json.array!(@transfers) do |transfer|
  json.extract! transfer, :id, :user_id, :recipient_id, :amount_cents, :note
  json.url transfer_url(transfer, format: :json)
end
