$filter_sensitive_word = FilterSensitiveWord.new()
$filter_sensitive_word.load("#{Rails.root}/lib/words/广告.txt")
$filter_sensitive_word.load("#{Rails.root}/lib/words/政治类.txt")
$filter_sensitive_word.load("#{Rails.root}/lib/words/涉枪涉爆违法信息关键词.txt")
$filter_sensitive_word.load("#{Rails.root}/lib/words/色情类.txt")