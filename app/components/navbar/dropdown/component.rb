# frozen_string_literal: true

class Navbar::Dropdown::Component < ApplicationViewComponent
  option :label, default: -> { "Dropdown" }, required: false
  option :chevron, default: -> { true }, required: false
  renders_one :custom_content

  def item(**)
    render(Navbar::Dropdown::Item::Component.new(**))
  end
end
