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

    profile { build(:profile) }

    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :nonboarded do
      profile { nil }
      after(:create) do |user, _evaluator|
        user.accounts.delete_all
        user.members.delete_all
      end
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
      user.members.create(account: create(:account), owner: true)
    end

    trait :with_accounts do
      after(:create) do |user, evaluator|
        if evaluator.accounts_count > 0
          evaluator.accounts_count.times do
            account = create(:account)
            create(:member, user: user, account: account)
          end
        end
      end
    end
  end
end
