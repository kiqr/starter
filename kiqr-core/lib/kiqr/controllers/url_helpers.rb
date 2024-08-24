module Kiqr
  module Controllers
    module UrlHelpers
      # Generate a URL for the invitation token.
      def invitation_token_url(token)
        user_invitation_url(token: token, account_id: nil)
      end

      # Check if the current path matches the base path provided, ignoring query parameters.
      def current_base_path?(path)
        request.path.start_with?(path.split("?").first)
      end
    end
  end
end
