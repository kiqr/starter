module Kiqr
  module Frontend
    module ViewHelpers
      # Generate a QR code for the given text.
      # This is used to generate a QR code for the user's two factor authentication app.
      def render_qr_code(content)
        RQRCode::QRCode.new(content).as_svg(
          module_size: 4
        ).html_safe
      end
    end
  end
end
