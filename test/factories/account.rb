FactoryBot.define do
  factory :account do
    transient do
      users_count { 0 }
    end

    sequence(:name) { |n| "Account #{n}" }
    personal { false }

    trait :with_users do
      after(:create) do |account, evaluator|
        if evaluator.users_count > 0
          evaluator.users_count.times do
            user = create(:user)
            create(:member, user: user, account: account, owner: false)
          end
        end
      end
    end
  end
end
