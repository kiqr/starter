# frozen_string_literal: true

class PageLayouts::Settings::NavigationItem::Component < ApplicationViewComponent
  option :label
  option :description
  option :icon
  option :path
  option :active, optional: true, default: false

  def is_active?
    current_page?(path) || active
  end
end
