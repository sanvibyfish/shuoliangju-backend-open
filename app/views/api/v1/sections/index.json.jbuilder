json.array! @sections do |section|
  json.partial! 'section', section: section
end