FactoryBot.define do
    factory :board do
      association :user,factory: :user
      association :app,factory: :app
    end

end
