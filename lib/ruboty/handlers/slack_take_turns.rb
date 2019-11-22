module Ruboty
  module Handlers
    # manage a duty that members in a slack channel take turns on
    class SlackTakeTurns < Base
      NAMESPACE = "slack_take_turns"

      on(
        /members/,
        name: "members",
        description: "#{I18n.t 'messages.handlers.members'}"
      )
      on(
        /force (?<user_name>.+?)\z/,
        name: "force",
        description: "#{I18n.t 'messages.handlers.force'}",
      )
      on(
        /current/,
        name: "current",
        description: "#{I18n.t 'messages.handlers.current'}",
      )
      on(
        /next/,
        name: "next",
        description: "#{I18n.t 'messages.handlers.next'}",
      )
      on(
        /exclude (?<space_separated_user_names>.+?)\z/,
        name: "exclude",
        description: "#{I18n.t 'messages.handlers.exclude'}",
      )
      on(
        /include (?<space_separated_user_names>.+?)\z/,
        name: "include",
        description: "#{I18n.t 'messages.handlers.include'}",
      )
      on(
        /(?<keyword>#{ENV['ASSIGN_REGEX']})/m,
        name: "assign",
        description: "#{I18n.t 'messages.handlers.assign'}",
        all: true,
      )

      env :SLACK_TOKEN, "Browse Apps > Custom Integrations > Bots > API Token"
      env :ASSIGN_REGEX, "e.g. .*http:\/\/github.com.*"

      def members(message)
        Ruboty::SlackTakeTurns::Actions::Members.new(message).call
      end

      def force(message)
        Ruboty::SlackTakeTurns::Actions::Force.new(message).call
      end

      def current(message)
        Ruboty::SlackTakeTurns::Actions::Current.new(message).call
      end

      def next(message)
        Ruboty::SlackTakeTurns::Actions::Next.new(message).call
      end

      def exclude(message)
        Ruboty::SlackTakeTurns::Actions::Exclude.new(message).call
      end

      def include(message)
        Ruboty::SlackTakeTurns::Actions::Include.new(message).call
      end

      def assign(message)
        Ruboty::SlackTakeTurns::Actions::Assign.new(message).call
      end

    end
  end
end
