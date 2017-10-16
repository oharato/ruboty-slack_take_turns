module Ruboty
  module SlackTakeTurns
    module Actions
      class Assign < Base
        def call
          message.reply(assign)
        rescue ActionBaseError => e
          message.reply(e.message)
          Ruboty.logger.info e.to_s
        rescue => e
          message.reply(e.message)
          raise e
        end

        private

        def assign
          # avoid self-repeating
          return if message.from_name == message.robot.name
          keyword = message[:keyword]
          "#{I18n.t 'messages.actions.assign', current_user_name: current_user_name, keyword: keyword}"
        end

      end
    end
  end
end
