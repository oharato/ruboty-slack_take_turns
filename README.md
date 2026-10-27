# Ruboty::SlackTakeTurns

Ruboty plugin to manage a duty that members in a slack channel take turns on

## Dependencies
- Ruby 4.0 or later (development and CI: Ruby 4.0.9)
- ruboty 1.4.1 or later
- slack-ruby-client 3.3.x

### Migrating from the legacy Slack adapter

This plugin no longer installs `ruboty-slack_rtm`. Its dependency chain pins
vulnerable versions of Faraday and faye-websocket. Slack Web API calls now use
`Slack::Web::Client`; `SLACK_TOKEN` remains the bot token used by this plugin.
Configure a compatible Slack message-receiving adapter separately in your bot
application. Keeping `ruboty-slack_rtm` in the application's Gemfile conflicts
with the patched Faraday 2.x required here, so migrate that adapter before upgrading.
This plugin alone does not receive Slack events.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-slack_take_turns'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruboty-slack_take_turns

## ENV
```
SLACK_TOKEN - Browse Apps > Custom Integrations > Bots > API Token
ASSIGN_REGEX - e.g. .*http:\/\/example.com\/issues.*
# Default language is English. If you add below, messages is displayed in Japanese.
SLACK_TAKE_TURNS_LANG=ja
```

## Commands
```
ruobty /current/ - show who is on duty currently
ruobty /exclude (?<user_name>.+?)\z/ - make a specified member to not be on duty after this
ruobty /include (?<user_name>.+?)\z/ - make a specified member to be on duty after this
ruobty /force (?<user_name>.+?)\z/ - make a specified member to be on duty
ruobty /members/ - member list in a channel(order by slack-user-id asc)
ruobty /next/ - pass on a duty to the next member
/(?<keyword>.*http:\/\/example.com\/issues.*)/m - When a macthed keyword is posted, the bot assigns a person on duty to a task related the keyword.
```

## Usage

### check members
```
> ruboty members
oharato, jimmy, ellen, ruboty
```

### set the first person on duty
```
> ruboty force oharato
made @oharato to take over a duty
```

check current status
```
> ruboty current
@oharato is on duty now.
```

```
> ruboty members
[flag]oharato, jimmy, ellen, ruboty
```

### post a keyword you set in .env
```
> http://example.com/issues/42
@oharato, please deal with the task below.
http://example.com/issues/42
```

### pass on a duty to the next member
```
> ruboty next
passed on a duty to the next member. @jimmy is on duty now.
```

## Notice
- You should use a ruboty brain plugin such as ruboty-local_yaml and ruboty-redis.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Run `bundle exec rake` for tests and `bundle exec bundler-audit check --update`
for dependency vulnerability checks. `Gemfile.lock` is tracked to reproduce the
audited development dependencies. CI runs both checks on Ruby 4; CodeQL scans
Ruby code, and Dependabot checks gem and GitHub Actions updates weekly.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/oharato/ruboty-slack_take_turns.

