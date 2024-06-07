require "test_helper"

class RoutingTest < ActionDispatch::IntegrationTest
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers

  setup do
    @routes = Rails.application.routes
  end

  test "kiqr routes setup default controllers" do
    assert_recognizes({ controller: "kiqr/accounts", action: "new" }, "/accounts/new")
    assert_recognizes({ controller: "kiqr/accounts", action: "select" }, "/select-account")
    # assert_recognizes({controller: "users/sessions", action: "new"}, "/users/login")
  end

  test "account routes are correctly configured" do
    assert_routing "/accounts/new", { controller: "kiqr/accounts", action: "new" }
    assert_routing "/select-account", { controller: "kiqr/accounts", action: "select" }
    assert_routing({ method: "post", path: "/accounts" }, { controller: "kiqr/accounts", action: "create" })
  end

  # test "devise routes for users are correctly configured" do
  #   assert_routing "/users/login", {controller: "users/sessions", action: "new"}
  #   assert_routing "/users/create-account", {controller: "users/registrations", action: "new"}
  # end
end
