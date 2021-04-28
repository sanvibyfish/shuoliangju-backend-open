FactoryBot.define do
    factory :post do
        body {"xxxx"}
        association :app, strategy: :build
        association :user, factory: :random_user
        association :section, factory: :section
    end

    factory :media_post, parent: :post do
        images_url {["http://x.com/1","http://x.com/2"]}
    end

end
