# surenotify_rails (電子豹非官方 Rails 套件)

*surenotify_rails* is an Action Mailer adapter for using 電子豹 [Surenotify](https://newsleopard.com/surenotify) in Rails apps. It uses the [Surenotify API](https://newsleopard.com/surenotify/api/v1/) internally.

## Installing

In your `Gemfile`

```ruby
gem 'surenotify_rails'
```

## Usage

To configure your Surenotify credentials place the following code in the corresponding environment file (`development.rb`, `production.rb`...)

```ruby
config.action_mailer.delivery_method = :surenotify
config.action_mailer.surenotify_settings = { api_key: '<surenotify api key>' }
```

Now you can send emails using plain Action Mailer:

```ruby
email = mail from: 'sender@email.com', to: 'receiver@email.com', subject: 'this is an email'
or
email = mail from: 'Your Name Here <sender@email.com>', to: 'receiver@email.com', subject: 'this is an email'
```

Pull requests are welcomed


