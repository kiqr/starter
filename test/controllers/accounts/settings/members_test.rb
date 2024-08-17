require "test_helper"

class Accounts::Settings::MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = create(:account, :with_users, users_count: 2)
    @user = create(:user, with_account: @account)
    sign_in @user
  end

  test "can render members index" do
    get account_settings_members_path(account_id: @account)

    assert_equal 3, assigns(:members).count
    assert_equal @user, assigns(:members).first.user
  end

  test "can't render members index as personal account" do
    assert_raises(ActionController::UrlGenerationError) do
      get account_settings_members_path
    end
  end

  test "can create a new member / invitation" do
    # Expect account.members.count to increase with one.
    assert_difference "@account.members.count", 1 do
      post account_settings_members_path(account_id: @account), params: { member: { invitation_email: "foo@zoo.com" } }
    end

    assert_redirected_to account_settings_members_path(account_id: @account)

    assert_equal 4, @account.members.count
    assert_equal 3, @account.members.accepted.count
    assert_equal 1, @account.members.pending.count
  end

  test "validates invitation email" do
    assert_no_difference "@account.members.count" do
      post account_settings_members_path(account_id: @account), params: { member: { invitation_email: "foo" } }
    end

    assert_response :unprocessable_content
  end

  test "can't invite a user to someone else team" do
    foreign_account = create(:account, name: "Foreign account")

    assert_raises(PublicUid::RecordNotFound) do
      post account_settings_members_path(account_id: foreign_account), params: { member: { invitation_email: "foobar@agag.com" } }
    end
  end

  test "can only invite the same user once" do
    post account_settings_members_path(account_id: @account), params: { member: { invitation_email: "foobar@foobar.com" } }
    assert_redirected_to account_settings_members_path(account_id: @account)

    assert_no_difference -> { @account.members.count } do
      post account_settings_members_path(account_id: @account), params: { member: { invitation_email: "foobar@foobar.com" } }
    end
  end

  test "can't remove the team owner" do
    skip "not implemented yet"
  end

  test "can remove a member from team" do
    skip "not implemented yet"
  end
end
