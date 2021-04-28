FactoryBot.define do
    factory :product do
        association :user, factory: :random_user
    end

end
