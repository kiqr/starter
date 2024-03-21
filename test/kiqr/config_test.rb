require "test_helper"

module Kiqr
  class ConfigTest < ActiveSupport::TestCase
    test "it can set and read config values" do
      Kiqr::Config.app_name = "Foobar"
      assert Kiqr::Config.app_name == "Foobar"
    end
  end
end
