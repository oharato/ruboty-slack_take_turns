module Ruboty
  module SlackTakeTurns
    module Actions
      class Current < Base
        def call
          message.reply(current)
        rescue ActionBaseError => e
          message.reply(e.message)
          Ruboty.logger.info e.to_s
        rescue => e
          message.reply(e.message)
          raise e
        end

        private

        def current
          "#{I18n.t 'messages.actions.current', current_user_name: current_user_name}"
        end

      end
    end
  end
end
