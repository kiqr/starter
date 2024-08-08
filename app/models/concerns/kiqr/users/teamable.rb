module Kiqr
  module Users
    module Teamable
      extend ActiveSupport::Concern

      included do
        # User can have many team accounts.
        has_many :account_users, dependent: :destroy
        has_many :accounts, through: :account_users
      end
    end
  end
end
