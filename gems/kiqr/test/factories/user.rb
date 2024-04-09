FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "generic-user-#{n}@example.com" }
    password { "th1s1sp4ssw0rd" }
    password_confirmation { "th1s1sp4ssw0rd" }
    confirmed_at { Time.zone.now }
    personal_account { build(:account, personal: true) }

    # trait :unconfirmed do
    #   confirmed_at { nil }
    # end

    # trait :otp_enabled do
    #   otp_required_for_login { true }
    #   otp_secret { User.generate_otp_secret }
    # end
  end
end
