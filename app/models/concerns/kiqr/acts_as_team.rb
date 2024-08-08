module Kiqr
  module ActsAsTeam
    extend ActiveSupport::Concern

    included do
      has_many :users, through: :account_users
      has_many :account_users, dependent: :destroy
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
