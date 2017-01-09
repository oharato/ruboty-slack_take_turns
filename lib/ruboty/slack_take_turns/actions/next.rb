module Ruboty
  module SlackTakeTurns
    module Actions
      class Next < Base
        def call
          message.reply(_next)
        rescue ActionBaseError => e
          message.reply(e.message)
          Ruboty.logger.info e.to_s
        rescue => e
          message.reply(e.message)
          raise e
        end

        private

        def _next
          self.current_user_id = find_next
          "passed on a duty to the next member. @#{current_user_name} is on duty now."
        end

        def find_next
          raise(CurrentUserNotFound.new(chat_message: message)) unless current_user_id
          idx = target_user_ids.index(current_user_id)
          raise UserNotFound.new(chat_message: message, user_id: current_user_id) unless idx
          if idx == target_user_ids.size - 1
            target_user_ids.first
          else
            target_user_ids[idx+1]
          end
        end

      end
    end
  end
end
