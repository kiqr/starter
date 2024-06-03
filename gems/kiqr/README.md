# Kiqr
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "kiqr"
```

And then execute:
```bash
$ bundle
```

Include the framework in your ApplicationController:

```ruby
class ApplicationController < ActionController::Base
  include Kiqr::Framework
end
```

Add the default routes to your routes.rb:

```ruby
# => KIQR core routes
# These routes are required for the KIQR core to function properly.
kiqr_routes

# => Teamable scope
# Routes inside this block will be prefixed with /team/<team_id> if
# the user is signed in to a team account. Otherwise, they won't be prefixed at all.
teamable_scope do
  get "dashboard" => "dashboard#show"
end

# Defines the root path route ("/")
root "public#landing_page"
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
