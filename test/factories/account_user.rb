FactoryBot.define do
  factory :account_user do
    user
    account
    owner { true }
  end
end
