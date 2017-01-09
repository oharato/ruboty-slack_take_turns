module Ruboty
  module Handlers
    # manage a duty that members in a slack channel take turns on
    class SlackTakeTurns < Base
      NAMESPACE = "slack_take_turns"

      on(
        /members/,
        name: "members",
        description: "member list in a channel(order by slack-user-id asc)"
      )
      on(
        /force (?<user_name>.+?)\z/,
        name: "force",
        description: "make a specified member to be on duty",
      )
      on(
        /current/,
        name: "current",
        description: "show who is on duty currently",
      )
      on(
        /next/,
        name: "next",
        description: "pass on a duty to the next member",
      )
      on(
        /exclude (?<user_name>.+?)\z/,
        name: "exclude",
        description: "make a specified member to not be on duty after this",
      )
      on(
        /(?<keyword>#{ENV['ASSIGN_REGEX']})/m,
        name: "assign",
        description: "When a macthed keyword is posted, the bot assigns a person on duty to a task related the keyword.",
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

      def assign(message)
        Ruboty::SlackTakeTurns::Actions::Assign.new(message).call
      end

    end
  end
end
