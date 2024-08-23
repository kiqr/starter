module Kiqr
  module Controllers
    module UrlHelpers
      # Check if the current path matches the base path provided, ignoring query parameters.
      def current_base_path?(path)
        request.path.start_with?(path.split("?").first)
      end
    end
  end
end
