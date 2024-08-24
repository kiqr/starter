module Kiqr
  module Models
    AVAILABLE_MODELS = %w[account member omniauth_identity user].freeze

    # This will allow us to use the kiqr method in the models
    # to include the appropriate module for the specific model.
    #
    # Example:
    # class User < ApplicationRecord
    #  kiqr model: :user
    # end
    def kiqr(model:)
      raise ArgumentError, "Invalid model: #{model}" unless AVAILABLE_MODELS.include?(model.to_s)

      klass_name = model.to_s.camelize
      include Kiqr::Models.const_get(klass_name)
    end
  end
end
