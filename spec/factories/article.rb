FactoryBot.define do
    factory :article do
        content {"xxxx"}
        association :app, strategy: :build
        association :user, factory: :random_user
    end

end
