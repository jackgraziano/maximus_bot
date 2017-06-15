Slack.configure do |config|
  config.token = ENV['SLACK_BOT_KEY']
end
@client = Slack::Web::Client.new

def send_slack(channel, message)
  @client.chat_postMessage(channel: channel, text: message, as_user: true)
end


def send_file(channel, file)
  @client.files_upload(
    channels: channel,
    as_user: true,
    file: Faraday::UploadIO.new('data/send/ipdo.pdf', 'application/pdf'),
    title: file,
    filename: file,
    initial_comment: 'Segue o ' + file + '!'
  )
end
