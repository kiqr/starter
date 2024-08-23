module Kiqr
  class CurrentAttributes < ActiveSupport::CurrentAttributes
    attribute :account, :user
  end
end
