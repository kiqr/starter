require "test_helper"

class AccountUserTest < ActiveSupport::TestCase
  test "should have the owner role" do
    assert_includes AccountUser::ROLES, "owner"
  end
end
