# The onboarding process is the process of creating a personal
# account for the user. This is the first step in the process
# of creating a personal user account. The user must have a personal
# account before they can create any other type of account.
#
# A user is considered to have completed the
# onboarding process if they have a personal account.
module Kiqr
  class OnboardingController < KiqrController
    skip_before_action :ensure_onboarded

    before_action do
      # This is to prevent users from accessing the onboarding process
      # if they have already completed it. A user can only have one
      # personal account. If they have one, they have completed the
      # onboarding process.
      redirect_to after_onboarding_path if current_user.onboarded?
    end

    def new
      @user = current_user
      @user.build_personal_account
    end

    def create
      @user = current_user
      @user.assign_attributes(user_params)
      @user.personal_account&.personal = true

      if @user.valid?
        Kiqr::Services::Users::Update.call!(user: @user)
        kiqr_flash_message(:notice, :settings_updated)
        redirect_to after_sign_in_path_for(@user)
      else
        render :new, status: :unprocessable_entity
      end
      # @account = Account.new(account_params)

      # if @account.valid?
      #   Kiqr::Services::Accounts::Create.call!(account: @account, user: current_user, personal: true)
      #   kiqr_flash_message(:notice, :account_created)
      #   redirect_to after_onboarding_path
      # else
      #   render :new, status: :unprocessable_entity
      # end
    end

    private

    def user_params
      personal_account_attributes = Kiqr.config.account_attributes.prepend(:id)
      params.require(:user).permit(:time_zone, :locale, personal_account_attributes: personal_account_attributes)
    end

    # This is the path to redirect to after the onboarding process
    # is completed. By default, it redirects to the dashboard.
    def after_onboarding_path
      dashboard_path
    end

    def form_submit_path
      onboarding_path
    end
    helper_method :form_submit_path

    def form_method
      :post
    end
    helper_method :form_method
  end
end
