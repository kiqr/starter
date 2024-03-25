class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action do
    redirect_to onboarding_path unless current_user.onboarded?
  end

  def show
  end
end
