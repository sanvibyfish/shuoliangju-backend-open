if product
  json.(product,:id,:body,:price)
  if product.images_url
    json.images_url JSON.parse(product.images_url)
    json.thumbnails_url JSON.parse(product.images_url).map { |url|
      "#{url}?x-oss-process=image/resize,h_180,w_120"
    }
  end
  json.created_at (product.created_at.to_f * 1000).to_i
  json.user do
    json.partial! "user", user: product.user
  end
  json.partial! "abilities", object: product
end        