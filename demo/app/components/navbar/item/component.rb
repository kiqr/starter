# frozen_string_literal: true

class Navbar::Item::Component < ApplicationViewComponent
  option :label, optional: true
  option :icon, optional: true
  option :path
  option :active, optional: true, default: false

  def is_active?
    current_page?(path) || active
  end
end
