json.array! @members do |user|
  json.partial! 'user', user: user
end