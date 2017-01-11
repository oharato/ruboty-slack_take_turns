# Ruboty::SlackTakeTurns

Ruboty plugin to manage a duty that members in a slack channel take turns on

## Dependencies
- ruboty
- ruboty-slack_rtm

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
```
## Commands
```
ruobty /current/ - show who is on duty currently
ruobty /exclude (?<user_name>.+?)\z/ - make a specified member to not be on duty after this
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

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/oharato/ruboty-slack_take_turns.

