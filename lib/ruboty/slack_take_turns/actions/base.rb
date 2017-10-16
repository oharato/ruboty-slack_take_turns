module Ruboty
  module SlackTakeTurns
    module Actions
      class Base
        NAMESPACE = 'slack_take_turns'

        attr_reader :message

        def initialize(message)
          @message = message
        end

        def channel
          message.to
        end

        def sender_id
          message.from
        end

        def data
          message.robot.brain.data[NAMESPACE] ||= {}
        end

        def channel_data
          data[channel] ||= {}
        end

        def current_user_id
          channel_data[:current_user_id]
        end

        def current_user_id=(id)
          channel_data[:current_user_id] = id
        end

        def slack_client
          @slack_client ||= Ruboty::SlackTakeTurns::SlackClient.new(channel)
        end

        def target_user_ids
          slack_client.channel_user_ids - excluded_user_ids
        end

        def excluded_user_ids
          channel_data[:excluded_user_ids] ||= []
        end

        def current_user_name
          find_user_by_user_id(current_user_id)['name']
        rescue
          raise CurrentUserNotFound.new(chat_message: message)
        end

        def find_user_by_user_id(user_id)
          slack_client.all_users_hash[user_id] || raise(UserNotFound.new(user_id: user_id, chat_message: message))
        end

        def find_user_id_by_user_name(user_name)
          user = slack_client.all_users.find{|u| u['name'] == user_name}
          user ? user['id'] : raise(UserNotFound.new(user_name: user_name, chat_message: message))
        end

        class ActionBaseError < StandardError
          def initialize(chat_message: nil, user_id: nil, user_name: nil)
            @chat_message = chat_message
            @user_id = user_id
            @user_name = user_name
          end

          def to_s
            <<~"EOF"
            #{self.class.to_s}
            user_id:#{@user_id}, user_name:#{@user_name}, from:#{@chat_message.from_name}, channel:#{@chat_message.to}, body:#{@chat_message.body}
            #{backtrace.take(4).join("\n")}
            EOF
          end
        end

        class CurrentUserNotFound < ActionBaseError
          def message
            "#{I18n.t 'errors.current_user_not_found'}"
          end
        end

        class UserNotFound < ActionBaseError
          def message
            "#{I18n.t 'errors.user_not_found', user_name: @user_name}"
          end
        end

      end
    end
  end
end
