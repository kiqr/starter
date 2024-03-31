class Users::CancellationsController < ApplicationController
  def show
    # Get a list of accounts where the current user is the owner.
    @conflicting_account_users = current_user.account_users.where(role: "owner")
  end
end
