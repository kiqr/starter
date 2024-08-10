FactoryBot.define do
  factory :user do
    transient do
      with_account { nil }
      accounts_count { 0 }
    end

    sequence(:email) { |n| "generic-user-#{n}@example.com" }
    password { "th1s1sp4ssw0rd" }
    password_confirmation { "th1s1sp4ssw0rd" }
    confirmed_at { Time.zone.now }
    personal_account { build(:account, personal: true) }

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

    after(:create) do |user, evaluator|
      if evaluator.with_account
        # Build the association with 'owner: true'
        user.account_users.create(account: evaluator.with_account, owner: true)
      end
    end

    trait :with_accounts do
      after(:create) do |user, evaluator|
        if evaluator.accounts_count > 0
          evaluator.accounts_count.times do
            account = create(:account)
            create(:account_user, user: user, account: account)
          end
        end
      end
    end
  end
end
