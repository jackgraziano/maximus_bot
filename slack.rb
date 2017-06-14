require 'slack-ruby-client'
require 'uri'
require 'net/http'

Slack.configure do |config|
  config.token = 'xoxb-198073611270-B8LdK1DLejpmLbQWBhlKMKT4'
end
@client = Slack::Web::Client.new

def send_slack(channel, message)
  @client.chat_postMessage(channel: channel, text: message, as_user: true)
end


def send_file(channel, file)
  @client.files_upload(
    channels: channel,
    as_user: true,
    file: Faraday::UploadIO.new('ipdo.pdf', 'application/pdf'),
    title: file,
    filename: file,
    initial_comment: 'Segue o ' + file + '!'
  )
end
