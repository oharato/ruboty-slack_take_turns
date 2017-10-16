module Ruboty
  module SlackTakeTurns
    module Actions
      class Include < Base
        def call
          message.reply(include)
        rescue ActionBaseError => e
          message.reply(e.message)
          Ruboty.logger.info e.to_s
        rescue => e
          message.reply(e.message)
          raise e
        end

        private

        def include
          user_name = message[:user_name]
          user_id = find_user_id_by_user_name(user_name)
          if excluded_user_ids.include? user_id
            excluded_user_ids.delete user_id
          end
          "#{I18n.t 'messages.actions.include', user_name: user_name}"
        end

      end
    end
  end
end
