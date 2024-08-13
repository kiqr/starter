class Accounts::Settings::MembersController < Accounts::Settings::ApplicationController
  before_action do
    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("breadcrumbs.settings.members"), account_settings_members_path
  end

  def index
    @members = @account.members.includes(:user).references(:user).order(owner: :desc, invitation_accepted_at: :desc)
  end

  def new
    @member = @account.members.new
  end

  def create
    @member = @account.members.new(member_params)
    @member.invited_by = find_current_member

    if @member.save
      @member.send_invitation_email
      kiqr_flash_message :success, :invitation_created
      redirect_to account_settings_members_path
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def find_current_member
    @current_member ||= @account.members.find_by(user: current_user)
  end

  def member_params
    params.require(:member).permit(:invitation_email)
  end
end
