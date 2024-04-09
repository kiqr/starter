require "test_helper"

module Kiqr
  class ConfigTest < ActiveSupport::TestCase
    def setup
      Kiqr::Config.app_name = "Foobar"
    end

    test "it can set and read config values" do
      assert Kiqr::Config.app_name == "Foobar"
    end

    test "config can be accessed via Kiqr.config" do
      assert Kiqr.config.app_name == "Foobar"
    end
  end
end
