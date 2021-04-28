FactoryBot.define do
  factory :notifications,class: Notification do
    association :user
    association :actor, factory: :user
  end

  factory :comment_notifications, parent: :notifications do
    notify_type {"comment"}
    association :target, factory: :post_comment
    association :second_target, factory: :post

  end
  factory :reply_comment_notifications, parent: :notifications do
    notify_type {"reply_comment"}
    association :target, factory: :post_comment
    association :second_target, factory: :post_comment
    association :third_target, factory: :post

  end
  factory :like_notifications, parent: :notifications do
    notify_type {"like"}
    association :target, factory: :post
  end
end
