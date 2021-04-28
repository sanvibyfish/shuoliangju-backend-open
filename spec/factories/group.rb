FactoryBot.define do
    factory :group do
        association :user, factory: :random_user
    end

end
