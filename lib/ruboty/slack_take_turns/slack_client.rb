module Ruboty
  module SlackTakeTurns
    class SlackClient

      attr_reader :client, :channel

      def initialize(channel)
        @client ||= Slack::Client.new(token: ENV['SLACK_TOKEN'])
        @channel = channel
        @conversations_members = {}
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
          ids = conversations_members(channel)
          # 退職してアカウント停止した人とボットは除く
          ids = ids.select{|id| user = find_user_by_user_id(id); !user['deleted'] && !user['is_bot']}
          @channel_user_ids[channel] = ids.sort
        end
        @channel_user_ids[channel]
      end

      def conversations_members(channel)
        members = @conversations_members[channel]
        @conversations_members[channel] = client.conversations_members(channel: channel)['members'] unless members
        @conversations_members[channel]
      end

      def find_user_by_user_id(user_id)
        all_users_hash[user_id] || raise("user not found user_id: #{user_id}#")
      end

    end
  end
end
