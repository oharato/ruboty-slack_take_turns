module Ruboty
  module SlackTakeTurns
    module Actions
      class Force < Base
        def call
          message.reply(force)
        rescue ActionBaseError => e
          message.reply(e.message)
          Ruboty.logger.info e.to_s
        rescue => e
          message.reply(e.message)
          raise e
        end

        private

        def force
          user_name = message[:user_name]
          user_id = find_user_id_by_user_name(user_name)
          if target_user_ids.include? user_id
            channel_data[:current_user_id] = user_id
            "#{I18n.t 'messages.actions.force.ok', user_name: user_name}"
          else
            "#{I18n.t 'messages.actions.force.ng', user_name: user_name}"
          end
        end

      end
    end
  end
end
