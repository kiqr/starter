require "test_helper"

# This is a workaround for the issue with the chrome driver
# sometimes appends to an input rather than overwriting.
# https://github.com/teamcapybara/capybara/issues/2419
Capybara.default_set_options = { clear: :backspace }

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: (ENV["CI"] ? :headless_chrome : :chrome), screen_size: [ 1400, 1400 ] do |driver_options|
    driver_options.add_argument("disable-search-engine-choice-screen")
  end
end
