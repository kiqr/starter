module Kiqr
  module Accounts
    module ActsAsTeam
      extend ActiveSupport::Concern

      included do
        has_many :members, dependent: :destroy
        has_many :users, through: :members
        has_many :pending_invitations, -> { pending }, class_name: "Member"
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
