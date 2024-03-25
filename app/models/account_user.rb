class AccountUser < ApplicationRecord
  ROLES = %w[owner member]

  belongs_to :user
  belongs_to :account

  validates :role, presence: true, inclusion: {in: self::ROLES}
end
