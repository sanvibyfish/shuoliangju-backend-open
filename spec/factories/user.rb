FactoryBot.define do

    factory :user do
        nick_name {"xxxx"}
        openid {"123"}
        avatar_url {"http://x.com"}
        password {"12345678"}
        # cellphone {"12345678901"}
    end

    factory :random_user, parent: :user do
      sequence(:cellphone) {|n| "1234567890#{n}" }
    end

    factory :apps_user, parent: :user do
      factory :users do
        # languages_count is declared as an ignored attribute and available in
        # attributes on the factory, as well as the callback via the evaluator
        transient do
          apps_count { 5 }
        end
  
        # the after(:create) yields two values; the profile instance itself and
        # the evaluator, which stores all values from the factory, including
        # ignored attributes; `create_list`'s second argument is the number of
        # records to create and we make sure the profile is associated properly
        # to the language
        after(:create) do |user, evaluator|
          create_list(:app, evaluator.apps_count, users: [user])
        end
      end
    end
end
