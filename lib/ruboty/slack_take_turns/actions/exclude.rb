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
          user_names = message[:space_separated_user_names].strip.delete('@').split(/\s|,/).select{|name| !name.empty?}
          excluded_user_names = []
          user_names.each do |user_name|
            user_id = find_user_id_by_user_name(user_name)
            unless excluded_user_ids.include? user_id
              excluded_user_ids << user_id
              excluded_user_names << user_name
            end
          end
          return I18n.t 'messages.actions.exclude_failure' if excluded_user_names.empty?
          "#{I18n.t 'messages.actions.exclude', user_name: excluded_user_names.map{|name| "@#{name}"}.join(', ')}"
        end

      end
    end
  end
end
