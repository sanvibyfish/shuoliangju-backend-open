FactoryBot.define do
  factory :comment do
    body {"body"}
    association :user
    association :app, strategy: :build
  end

  factory :post_comment, parent: :comment do
    association :commentable, factory: :post
  end
end
