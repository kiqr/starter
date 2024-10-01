module Kiqr
  module Users
    module Profile
      extend ActiveSupport::Concern

      included do
        # Profile with name, avatar and other details.
        has_one :profile, dependent: :destroy
        accepts_nested_attributes_for :profile
        validates_associated :profile
      end
    end
  end
end
