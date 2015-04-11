json.array!(@languages) do |language|
  json.extract! language, :id, :name, :locale, :parent_id
  json.url language_url(language, format: :json)
end
