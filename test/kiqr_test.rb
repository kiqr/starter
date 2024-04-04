require "test_helper"

class KiqrTest < ActiveSupport::TestCase
  test "should set default_url_options to localhost:3000 in test environment" do
    assert_equal Kiqr.default_url_options, {host: "localhost", port: 3000, protocol: "http"}
  end

  test "it can override default_url_options with ENV['BASE_URL']" do
    ENV["BASE_URL"] = "https://example.com"
    assert_equal Kiqr.default_url_options, {host: "example.com", protocol: "https"}
    ENV["BASE_URL"] = nil
  end

  test "ActionMailer's default_url_option is set by default_url_options" do
    assert_equal Rails.configuration.action_mailer.default_url_options, Kiqr.default_url_options
  end
end
