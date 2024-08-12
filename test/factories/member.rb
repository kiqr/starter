FactoryBot.define do
  factory :member do
    user
    account
    owner { true }
  end
end
