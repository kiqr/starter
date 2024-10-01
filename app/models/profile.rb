class Profile < ApplicationRecord
  validates :name, presence: true
end
