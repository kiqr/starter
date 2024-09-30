module Kiqr
  module Users
    module Accounts
      extend ActiveSupport::Concern

      included do
        has_many :members, dependent: :destroy
        has_many :accounts, through: :members
      end
    end
  end
end
