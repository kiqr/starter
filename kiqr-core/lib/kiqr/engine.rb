module Kiqr
  class Engine < ::Rails::Engine
    # Include helpers to the applications controllers and views.
    initializer "kiqr.controller_and_view_helpers" do
      Kiqr.include_helpers(Kiqr::Controllers)
    end

    initializer "kiqr.set_current_request_details" do
      ActiveSupport.on_load(:action_controller) do
        include Kiqr::Controllers::SetCurrentRequestDetails
      end
    end
  end
end
