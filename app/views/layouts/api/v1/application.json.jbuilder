
json.code   200
json.message  @message.blank?  ? '' : @message
json.data JSON.parse(yield)