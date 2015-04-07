json.array!(@specimens) do |specimen|
  json.extract! specimen, :id
  json.url specimen_url(specimen, format: :json)
end
