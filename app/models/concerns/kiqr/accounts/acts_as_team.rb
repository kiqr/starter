module Kiqr
  module Accounts
    module ActsAsTeam
      extend ActiveSupport::Concern

      included do
        has_many :users, through: :members
        has_many :members, dependent: :destroy
        has_many :account_invitations, dependent: :destroy
      end

      def has_member?(user)
        users.include? user
      end

      def team?
        !personal
      end
    end
  end
end
