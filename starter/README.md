# My application

This is a starter kit for [KIQR](https://github.com/kiqr/kiqr) - the open-source framework that provides a solid foundation for building SaaS applications in Ruby on Rails.

This starter kit uses:

* The latest version of KIQR.
* Ruby 3.3.4 and Ruby on Rails 7.2.1

## Getting Started

Navigate into your app directory and execute the setup script. This will install all the dependencies, create the databases, and run the migrations.

```console
bin/setup
```

Start the Rails server.

```console
bin/rails server
```

### Configuration

Kiqr allows you to personalize your application through various configuration options. Set up your application's name, email settings, and locale preferences by adjusting the Kiqr configuration.

To configure your Kiqr application, edit the initializer file found at config/initializers/kiqr.rb. If this file does not exist, you might need to create it.

```ruby
Kiqr::Config.configure do |config|
  # ==> Application name
  # The name of the application. This will be displayed in the meta title
  # and on various places in the application.
  config.app_name = "My application"

  # ==> From email
  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you use your own mailer class
  # with default "from" parameter.
  config.default_from_email = "please-change-me-at-config-initializers@example.com"

  # ==> Account attributes
  # Strong parameters for account. Used for account creation and update.
  # Affects both personal and team accounts.
  config.account_attributes = %w[ name ]
end
````

### Upgrading KIQR

The KIQR command line application provides the `update` command. After updating the KIQR version in the `Gemfile`, run this command. This will help you with the creation of new files and changes of old files in an interactive session.

```console
bin/kiqr update
```
