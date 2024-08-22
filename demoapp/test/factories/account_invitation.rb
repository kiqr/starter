FactoryBot.define do
  factory :account_invitation do
    account { create(:account) }
    email { Faker::Internet.email }
  end
end
