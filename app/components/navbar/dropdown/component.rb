# frozen_string_literal: true

class Navbar::Dropdown::Component < ApplicationViewComponent
  option :label, optional: true
  option :chevron, default: -> { true }, optional: true
  option :icon, optional: true

  renders_one :custom_content

  def item(**)
    render(Navbar::Dropdown::Item::Component.new(**))
  end
end
