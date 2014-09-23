# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pickup_keyword do
    sequence :pickup_keyword do |n|
      "pickup_keyword#{n}"
    end
    sequence :slug do |n|
      "slug#{n}"
    end
  end
end
