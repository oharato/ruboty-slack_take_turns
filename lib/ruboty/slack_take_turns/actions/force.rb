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
            "made @#{user_name} to take over a duty"
          else
            "#{user_name} is free from a duty"
          end
        end

      end
    end
  end
end
