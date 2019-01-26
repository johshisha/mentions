class Webhooks::To::Slack
  def initialize(mention:, url:, additional_message:)
    @mention = "@#{mention}"
    @channel = ENV.fetch('SLACK_CHANNEL') || @mention
    @text = "#{@mention} #{url} #{additional_message}"
    @webhook_uri = ENV.fetch('SLACK_WEBHOOK_URL')
  end

  def post
    HttpPostJob.perform_later(@webhook_uri, { payload: {text: @text, link_names: 1, channel: @channel}.to_json })
  end
end
