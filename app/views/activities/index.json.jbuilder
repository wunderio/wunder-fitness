json.array!(@activities) do |activity|
  json.extract! activity, :id, :service_activity_id, :date, :distance, :integration_user_id
  json.url activity_url(activity, format: :json)
end
