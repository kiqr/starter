module Kiqr
  module Users
    module Teamable
      extend ActiveSupport::Concern

      included do
        # User can have many team accounts.
        has_many :members, dependent: :destroy
        has_many :accounts, through: :members
      end
    end
  end
end
