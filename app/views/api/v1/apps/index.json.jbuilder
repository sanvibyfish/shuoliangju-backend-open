json.array! @apps do |app|
  json.partial! 'app', app: app
end