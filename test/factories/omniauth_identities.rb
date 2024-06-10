FactoryBot.define do
  factory :omniauth_identity do
    user { create(:user) }
    provider { "developer" }
    sequence(:provider_uid) { |n| "external-#{n}@example.com" }
  end
end
