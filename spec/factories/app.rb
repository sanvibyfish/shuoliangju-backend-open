FactoryBot.define do
    factory :app do
      app_key {"sljxxxxxx"}
      name {"test"}
      summary {"hello"}
      association :own,factory: :user
      after(:create) { |app| app.own.apps << app  }
    end

end
