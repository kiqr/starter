require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: (ENV["CI"] ? :headless_chrome : :chrome), screen_size: [ 1400, 1400 ] do |driver_options|
    driver_options.add_argument("disable-search-engine-choice-screen")
  end
end
