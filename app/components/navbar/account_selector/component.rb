# frozen_string_literal: true

class Navbar::AccountSelector::Component < ApplicationViewComponent
  option :current_user, optional: true
  option :current_account, optional: true
end
