class Webhooks::To::Slack
  def initialize(mention:, url:, additional_message:)
    @mention = "@#{mention}"
    @channel = ENV.fetch('SLACK_CHANNEL') || @mention
    @text = "<#{@mention}> #{url} #{additional_message}"
    @webhook_uri = ENV.fetch('SLACK_WEBHOOK_URL')
  end

  def post
    payload_json = { payload: {text: @text, link_names: 1, channel: @channel}.to_json
    # FIXME: to_jsonで<>がescapeされてほしくないので，とりあえず無理やり修正している
    payload = payload_json.gsub(/\\u003c|\\u003e/, "\\u003c" => "<", "\\u003e" => ">")
    HttpPostJob.perform_later(@webhook_uri, { payload: {text: @text, link_names: 1, channel: @channel}.to_json })
  end
end
