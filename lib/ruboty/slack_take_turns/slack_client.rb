module Ruboty
  module SlackTakeTurns
    class SlackClient

      attr_reader :client, :channel

      def initialize(channel)
        @client ||= Slack::Client.new(token: ENV['SLACK_TOKEN'])
        @channel = channel
      end

      def all_users
        @all_users ||= client.users_list['members']
      end

      # ユーザを取得しやすくするためにユーザIDとユーザオブジェクトのハッシュテーブルを作る
      def all_users_hash
        @all_users_hash ||= {}.tap do |h|
          all_users.each{|u| h[u['id']] = u}
        end
      end

      # チャンネル内の全ユーザid
      def channel_user_ids
        unless @channel_user_ids&.dig(channel)
          @channel_user_ids = {} unless @channel_user_ids
          ids = private_channel? ? private_channel_user_ids : public_channel_user_ids
          @channel_user_ids[channel] = ids.sort
        end
        @channel_user_ids[channel]
      end

      def channels_info
        @channels_info ||= client.channels_info(channel: channel)
      end

      def public_channel_user_ids
        channels_info['channel']['members']
      end

      def private_channel_user_ids
        private_channels = groups_list
        current_channel = private_channels.find{|c| c['id'] == channel}
        current_channel['members']
      end

      def groups_list
        @groups_list ||= client.groups_list['groups']
      end

      def private_channel?
        channels_info['error'] == "channel_not_found"
      end

    end
  end
end
