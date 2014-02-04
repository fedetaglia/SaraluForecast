json.array!(@steps) do |step|
  json.extract! step, :id, :location, :lon, :lat, :arrive_on, :stay, :trip_id_id
  json.url step_url(step, format: :json)
end
