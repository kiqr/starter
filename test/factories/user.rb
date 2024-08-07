FactoryBot.define do
  factory :user do
    transient do
      with_account { nil }
    end

    sequence(:email) { |n| "generic-user-#{n}@example.com" }
    password { "th1s1sp4ssw0rd" }
    password_confirmation { "th1s1sp4ssw0rd" }
    confirmed_at { Time.zone.now }
    personal_account { build(:account, personal: true) }

    after(:create) do |user, evaluator|
      if evaluator.with_account
        # Build the association with 'owner: true'
        user.account_users.create(account: evaluator.with_account, owner: true)
      end
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :without_password do
      password { nil }
      password_confirmation { nil }
      to_create { |user| user.save(validate: false) }
    end

    trait :otp_enabled do
      otp_required_for_login { true }
      otp_secret { User.generate_otp_secret }
    end
  end
end
