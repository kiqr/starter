module Kiqr
  module Members
    module ActsAsMember
      extend ActiveSupport::Concern

      included do
        belongs_to :user, required: false
        belongs_to :account
      end
    end
  end
end
