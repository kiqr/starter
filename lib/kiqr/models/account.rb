module Kiqr
  module Models
    module Account
      extend ActiveSupport::Concern
      include PublicUid::ModelConcern

      included do
        has_many :members, dependent: :destroy
        has_many :users, through: :members
        has_many :pending_invitations, -> { pending }, class_name: "Member"

        validates :name, presence: true, length: { minimum: 3, maximum: 255 }
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
