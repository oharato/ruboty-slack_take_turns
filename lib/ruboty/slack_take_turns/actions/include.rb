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
          user_names = message[:space_separated_user_names].strip.delete('@').split(/\s|,/).select{|name| !name.empty?}
          included_user_names = []
          user_names.each do |user_name|
            user_id = find_user_id_by_user_name(user_name)
            if excluded_user_ids.include? user_id
              excluded_user_ids.delete user_id
              included_user_names << user_name
            end
          end
          return I18n.t 'messages.actions.include_failure' if included_user_names.empty?
          "#{I18n.t 'messages.actions.include', user_name: included_user_names.map{|name| "@#{name}"}.join(', ')}"
        end

      end
    end
  end
end
