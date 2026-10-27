require "minitest/autorun"
require "ruboty/slack_take_turns"

class SlackTakeTurnsTest < Minitest::Test
  Message = Struct.new(:robot, :to, :from, :from_name, :body, :params, :replies) do
    def [](key) = params[key]
    def reply(text) = replies << text
  end

  def setup
    I18n.locale = :en
    @message = Message.new(
      Struct.new(:brain, :name).new(Struct.new(:data).new({}), "ruboty"),
      "C123", "U1", "alice", "test", {}, []
    )
    @slack = Ruboty::SlackTakeTurns::SlackClient.new("C123")
    @requests = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("/api/users.list") do
        [200, { "Content-Type" => "application/json" }, JSON.generate(
          ok: true, members: [
            { id: "U2", name: "bob", deleted: false, is_bot: false },
            { id: "U1", name: "alice", deleted: false, is_bot: false },
            { id: "U3", name: "bot", deleted: false, is_bot: true },
            { id: "U4", name: "deleted", deleted: true, is_bot: false }
          ]
        )]
      end
      stub.post("/api/conversations.members") do |env|
        assert_equal "C123", URI.decode_www_form(env.body).to_h["channel"]
        [200, { "Content-Type" => "application/json" },
         JSON.generate(ok: true, members: %w[U4 U3 U2 U1])]
      end
    end
    @slack.client.send(:connection).builder.adapter :test, @requests
  end

  def run_action(name, params = {})
    @message.params = params
    action = Ruboty::SlackTakeTurns::Actions.const_get(name).new(@message)
    action.instance_variable_set(:@slack_client, @slack)
    action.call
    @message.replies.last
  end

  def test_modern_client_filters_and_sorts_members
    assert_instance_of Slack::Web::Client, @slack.client
    assert_equal %w[U1 U2], @slack.channel_user_ids
    assert_equal "alice", @slack.find_user_by_user_id("U1")["name"]
    @requests.verify_stubbed_calls
  end

  def test_force_current_and_next_wraparound
    assert_equal "made @alice to take over a duty", run_action(:Force, user_name: "alice")
    assert_equal "@alice is on duty now.", run_action(:Current)
    assert_includes run_action(:Next), "@bob"
    assert_includes run_action(:Next), "@alice"
  end

  def test_exclude_include_and_member_listing
    assert_equal "alice, bob", run_action(:Members)
    assert_includes run_action(:Exclude, space_separated_user_names: "@bob"), "@bob"
    assert_equal "alice", run_action(:Members)
    assert_equal "bob is free from a duty", run_action(:Force, user_name: "bob")
    assert_includes run_action(:Include, space_separated_user_names: "@bob"), "@bob"
    assert_equal "alice, bob", run_action(:Members)
  end

  def test_assignment_and_self_message
    run_action(:Force, user_name: "alice")
    assert_includes run_action(:Assign, keyword: "https://example.com/issues/42"), "@alice"
    @message.from_name = "ruboty"
    assert_nil run_action(:Assign, keyword: "https://example.com/issues/42")
  end

  def test_missing_current_user_reports_expected_error
    assert_includes run_action(:Current), "use 'force' command"
  end

  def test_japanese_translations_load
    I18n.locale = :ja
    refute_match(/translation missing/i, I18n.t("messages.actions.current", current_user_name: "alice"))
  end
end
