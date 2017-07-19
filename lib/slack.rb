Slack.configure do |config|
  config.token = ENV['SLACK_BOT_KEY']
end
@client = Slack::Web::Client.new

def send_slack(channel, message)
  @client.chat_postMessage(channel: channel, text: message, as_user: true)
end


def send_ipdo_to_slack(file)
  @client.files_upload(
    channels: '#ipdo',
    as_user: true,
    file: Faraday::UploadIO.new("#{File.expand_path File.dirname(__FILE__)}/data/send/ipdo.pdf", 'application/pdf'),
    title: file,
    filename: file,
    initial_comment: 'Segue o ' + file + '!'
  )
end

def send_maps_to_slack(file)
  @client.files_upload(
    channels: '#mapas',
    as_user: true,
    file: Faraday::UploadIO.new("#{File.expand_path File.dirname(__FILE__)}/data/send/mapas.pdf", 'application/pdf'),
    title: file,
    filename: file,
    initial_comment: 'Seguem os mapas!'
  )
end
