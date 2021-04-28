FactoryBot.define do
    factory :white_list do
      association :white_listable, factory: :user
    end

    factory :create_app_white_list, parent: :white_list do
     action {"create_app"}
    end

end
