# frozen_string_literal: true

class Navbar::Component < ApplicationViewComponent
  renders_many :right_sections

  def dark_mode_switch
    render(Navbar::DarkModeSwitch::Component.new)
  end

  def account_selector
    render(Navbar::AccountSelector::Component.new)
  end

  def separator
    render(Navbar::Separator::Component.new)
  end
end
