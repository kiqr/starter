class Account < ApplicationRecord
  include PublicUid::ModelConcern
  include Kiqr::Accounts::ActsAsTeam

  # => Model validations
  validates :name, presence: true, length: { minimum: 3, maximum: 255 }
end
