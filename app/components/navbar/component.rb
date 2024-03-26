# frozen_string_literal: true

class Navbar::Component < ApplicationViewComponent
  renders_many :right_sections

  def dark_mode_switch
    render(Navbar::DarkModeSwitch::Component.new)
  end

  def account_selector(current_user:, current_account:)
    render(Navbar::AccountSelector::Component.new(current_user:, current_account:))
  end
end
