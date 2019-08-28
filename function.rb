require 'json'
require 'line/bot'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV['LINE_CHANNEL_ID']
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  }
end

def webhook(event:, context:)
  signature = event['headers']['X-Line-Signature']
  body = event['body']
  unless client.validate_signature(body, signature)
    return {statusCode: 400, body: JSON.generate('signature_error')}
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        bot_response = {
          type: 'text',
          text: "Your message is\n" + event.message['text']
        }
        client.reply_message(
          event['replyToken'],
          bot_response
        )
      end
    end
  end

  {statusCode: 200, body: JSON.generate('done')}
end