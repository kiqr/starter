FactoryBot.define do
  factory :member do
    user
    account
    owner { true }
    trait :accepted do
      invitation_accepted_at { Time.zone.now }
    end
  end
end
