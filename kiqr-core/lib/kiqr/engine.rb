module Kiqr
  class Engine < ::Rails::Engine
    # Include helpers to the applications controllers and views.
    initializer "kiqr.controller_and_view_helpers" do
      Kiqr.include_helpers(Kiqr::Controllers)
    end

    initializer "kiqr.model_helpers" do
      ActiveSupport.on_load(:active_record) do
        extend Kiqr::Models
      end
    end

    initializer "kiqr.set_current_request_details" do
      ActiveSupport.on_load(:action_controller) do
        include Kiqr::Controllers::SetCurrentRequestDetails
      end
    end

    initializer "kiqr.add_flash_types" do
      # Add more types of flash message to match the available variants in Irelia::Notification::Component.
      ActiveSupport.on_load(:action_controller) do
        add_flash_types :success, :warning
      end
    end
  end
end
