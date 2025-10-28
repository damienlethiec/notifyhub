FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organisation #{n}" }
    sequence(:siret) { |n| sprintf("%014d", 11000001500000 + n) }
  end
end
