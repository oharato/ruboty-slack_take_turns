require "i18n"
I18n.load_path = []
Dir.glob("#{File.expand_path('../slack_take_turns', __FILE__)}/locale/*.yml").each do |f|
  lang = []
  lang << f
  I18n.load_path << lang
end
I18n.enforce_available_locales = false
I18n.default_locale = ENV['SLACK_TAKE_TURNS_LANG'] ? ENV['SLACK_TAKE_TURNS_LANG'].to_sym : :en
require "ruboty"
require "ruboty/slack_take_turns/slack_client"
require "ruboty/slack_take_turns/actions/base"
require "ruboty/slack_take_turns/actions/assign"
require "ruboty/slack_take_turns/actions/current"
require "ruboty/slack_take_turns/actions/exclude"
require "ruboty/slack_take_turns/actions/include"
require "ruboty/slack_take_turns/actions/force"
require "ruboty/slack_take_turns/actions/members"
require "ruboty/slack_take_turns/actions/next"
require "ruboty/slack_take_turns/version"
require "ruboty/handlers/slack_take_turns"
module Ruboty
  module SlackTakeTurns
    # Your code goes here...
  end
end
