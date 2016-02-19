json.array!(@admin_positions) do |admin_position|
  json.extract! admin_position, :id, :title, :rank
  json.url admin_position_url(admin_position, format: :json)
end
