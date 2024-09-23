FactoryBot.define do
  factory :member do
    user
    account
    owner { true }
    invitation_email { user.email }
    invitation_accepted_at { Time.zone.now }

    trait :invitation do
      user { nil }
      account { nil }
      owner { false }
      invitation_email { Faker::Internet.email }
      invitation_accepted_at { nil }
    end
  end
end
