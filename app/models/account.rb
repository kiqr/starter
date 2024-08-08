class Account < ApplicationRecord
  include PublicUid::ModelConcern
  include Kiqr::ActsAsTeam

  # => Model validations
  validates :name, presence: true, length: { minimum: 3, maximum: 255 }

  # Include any custom methods here
end
