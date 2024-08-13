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

  test "can't create a invitation with invalid email" do
    assert_no_difference "@account.members.count" do
      post account_settings_members_path(account_id: @account), params: { member: { invitation_email: "foo" } }
    end

    assert_response :unprocessable_content
  end
end
