require "test_helper"

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  test "can invite a user" do
    user = create(:user)
    account = create(:account, name: "Team account")
    account.members << Member.create(user:, owner: true)

    sign_in user

    assert_difference -> { account.account_invitations.count } do
      post account_invitations_path(account_id: account), params: { account_invitation: { email: "foobar@agag.com" } }
    end

    assert_redirected_to account_invitations_path(account_id: account)
  end

  test "can't invite a user to someone else team" do
    user = create(:user)
    account = create(:account, name: "Team account")
    account.members << Member.create(user:, owner: true)

    foreign_account = create(:account, name: "Foreign account")

    sign_in user

    assert_raises(PublicUid::RecordNotFound) do
      post account_invitations_path(account_id: foreign_account), params: { account_invitation: { email: "foobar@agag.com" } }
    end
  end

  test "can only invite the same user once" do
    user = create(:user)
    account = create(:account, name: "Team account")
    account.members << Member.create(user:, owner: true)

    sign_in user

    post account_invitations_path(account_id: account), params: { account_invitation: { email: "foobar@foobar.com" } }
    assert_redirected_to account_invitations_path(account_id: account)

    assert_no_difference -> { account.account_invitations.count } do
      post account_invitations_path(account_id: account), params: { account_invitation: { email: "foobar@foobar.com" } }
    end
  end

  test "invitations validates email" do
    user = create(:user)
    account = create(:account, name: "Team account")
    account.members << Member.create(user:, owner: true)

    sign_in user

    assert_no_difference -> { account.account_invitations.count } do
      post account_invitations_path(account_id: account), params: { account_invitation: { email: "foo" } }
    end

    assert_response :unprocessable_entity
  end
end
