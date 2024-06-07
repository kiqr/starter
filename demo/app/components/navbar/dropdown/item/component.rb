# frozen_string_literal: true

class Navbar::Dropdown::Item::Component < ApplicationViewComponent
  option :label, default: -> { "Dropdown item" }
  option :icon, optional: true
  option :path
end
