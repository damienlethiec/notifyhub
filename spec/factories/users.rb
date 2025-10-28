FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.gouv.fr" }
    password { "password123" }
    association :organization
    role { :user }

    trait :admin do
      role { :admin }
    end
  end
end
