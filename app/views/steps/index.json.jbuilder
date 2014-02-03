json.array!(@steps) do |step|
  json.extract! step, :id, :location, :lon, :lat, :arrival, :stay, :trip_id_id
  json.url step_url(step, format: :json)
end
