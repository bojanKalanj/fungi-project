json.array!(@languages) do |language|
  json.extract! language, :id, :name, :slug_2, :slug_3
  json.url language_url(language, format: :json)
end
