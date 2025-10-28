FactoryBot.define do
  factory :notification do
    association :from_organization, factory: :organization
    association :to_organization, factory: :organization
    sequence(:title) { |n| "Notification #{n}" }
    body { "Ceci est le contenu de la notification" }
    status { "pending" }
    priority { "normal" }

    trait :urgent do
      priority { "urgent" }
    end

    trait :sent do
      status { "sent" }
    end
  end
end
