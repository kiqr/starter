FactoryBot.define do
  factory :profile do
    sequence(:name) { |n| "User profile #{n}" }
  end
end
