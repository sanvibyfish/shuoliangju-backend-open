if section
  json.(section,:id,:name,:icon_url,:summary, :role, :app_id)
  json.partial! "abilities", object: section
end