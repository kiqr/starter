module Kiqr
  class Engine < ::Rails::Engine
    engine_name "kiqr"

    # Load default_url_options automatically with KIQR. To set a custom URL in
    # production, set the `BASE_URL` environment variable to your apps domain.
    # It defaults to `http://localhost:3000` in the development and test environments.
    initializer "kiqr.setup_default_url_options" do
      config.action_mailer.default_url_options = Kiqr.default_url_options
    end

    # Include helpers to the applications controllers and views.
    initializer "kiqr.controller_and_view_helpers" do
      Kiqr.include_helpers(Kiqr::Controllers)
      Kiqr.include_helpers(Kiqr::Translations)
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

    # => Devise layouts
    # Set the layout for Devise controllers
    initializer "kiqr.devise_layout" do
      config.to_prepare do
        DeviseController.layout "public"
        Devise::RegistrationsController.layout proc { |controller| user_signed_in? ? "application" : "public" }
      end
    end
  end
end
