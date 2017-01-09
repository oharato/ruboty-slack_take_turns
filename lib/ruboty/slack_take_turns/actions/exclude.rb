module Ruboty
  module SlackTakeTurns
    module Actions
      class Exclude < Base
        def call
          message.reply(exclude)
        rescue ActionBaseError => e
          message.reply(e.message)
          Ruboty.logger.info e.to_s
        rescue => e
          message.reply(e.message)
          raise e
        end

        private

        def exclude
          user_name = message[:user_name]
          user_id = find_user_id_by_user_name(user_name)
          unless excluded_user_ids.include? user_id
            excluded_user_ids << user_id
          end
          "made @#{user_name} to not be on duty after this"
        end

      end
    end
  end
end
