FactoryBot.define do
    factory :section do
      name {"板块1"}
      icon_url {"http://x.com/1"}
      association :app
    end
end
