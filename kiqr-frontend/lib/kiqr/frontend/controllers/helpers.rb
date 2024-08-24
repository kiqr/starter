module Kiqr
  module Frontend
    module Controllers
      module Helpers
        extend ActiveSupport::Concern

        include Kiqr::Frontend::Controllers::RendersSubmenu
      end
    end
  end
end
