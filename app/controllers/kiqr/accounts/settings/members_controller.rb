class Kiqr::Accounts::Settings::MembersController < Kiqr::Accounts::Settings::BaseController
  rescue_from Kiqr::Errors::AccountOwnerDeletionError, with: :account_owner_deletion_error

  before_action :setup_member, only: %i[edit update destroy invitation_link_modal]
  before_action :setup_breadcrumbs

  def index
    @members = @account.members.includes(:user).references(:user).order(owner: :desc, invitation_accepted_at: :desc)
  end

  def new
    @member = @account.members.new
  end

  def edit
    add_breadcrumb t("kiqr.breadcrumbs.settings.accounts.members.edit"), edit_account_settings_member_path(@member)
  end

  def update
  end

  def destroy
    if @member.id == find_current_member.id
      @member.destroy!
      kiqr_flash_message :success, :account_leaved, account_name: @account.name
      redirect_to dashboard_path(account_id: nil)
    else
      @member.destroy!
      kiqr_flash_message :success, :member_deleted
      redirect_to account_settings_members_path
    end
  end

  def create
    @member = @account.members.new(member_params)

    if @member.save
      kiqr_flash_message :success, :invitation_created
      redirect_to account_settings_members_path
    else
      render :new, status: :unprocessable_content
    end
  end

  # Show the invitation link modal.
  def invitation_link_modal
    render turbo_stream: turbo_stream.update("invitation_link", partial: "kiqr/accounts/settings/members/invitation_link_modal", locals: { member: @member })
  end

  private

  def setup_breadcrumbs
    # This is to set the breadcrumbs for the onboarding process.
    add_breadcrumb I18n.t("kiqr.breadcrumbs.settings.accounts.members.index"), account_settings_members_path

    if action_name == "edit" || action_name == "update" || action_name == "destroy"
      add_breadcrumb @member.name, edit_account_settings_member_path(@member)
    end
  end

  def setup_member
    @member = @account.members.includes(:user).references(:user).find_puid(params[:id])
  end

  def find_current_member
    @current_member ||= @account.members.find_by(user: current_user)
  end

  def member_params
    params.require(:member).permit(:invitation_email).merge(invited_by: find_current_member)
  end

  def account_owner_deletion_error
    kiqr_flash_message :alert, :account_owner_deletion_error
    redirect_back fallback_location: account_settings_members_path
  end
end
