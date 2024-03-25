# frozen_string_literal: true

class Navbar::Dropdown::Component < ApplicationViewComponent
  option :label, default: -> { "Dropdown" }, required: false
  renders_one :custom_content
end
