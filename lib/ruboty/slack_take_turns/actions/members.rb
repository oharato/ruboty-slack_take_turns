module Ruboty
  module SlackTakeTurns
    module Actions
      class Members < Base
        def call
          message.reply(members)
        rescue ActionBaseError => e
          message.reply(e.message)
          Ruboty.logger.info e.to_s
        rescue => e
          message.reply(e.message)
          raise e
        end

        private
        def members
          user_names = target_user_ids.map do |id|
            name = find_user_by_user_id(id)['name']
            name = ":triangular_flag_on_post:#{name}" if id == current_user_id
            name
          end
          user_names.join(', ')
        end
      end
    end
  end
end
