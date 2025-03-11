# require 'dotenv/load'
require 'sinatra'
require 'twitch-api'
require 'httparty'

# require 'pry'

# api
class TwitchAPI
  CLIENT_ID = ENV['TWITCH_CLIENT_ID'].freeze
  CLIENT_SECRET = ENV['TWITCH_CLIENT_SECRET'].freeze

  def self.client
    tokens = TwitchOAuth2::Tokens.new(
      client: {
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET
      }
    )

    Twitch::Client.new(tokens:)
  end

  def self.user(username:)
    twitch_client = TwitchAPI.client
    data = twitch_client.get_users({ login: username }).data.first

    {
      id: data.id,
      broadcaster_type: data.broadcaster_type,
      display_name: data.display_name,
      description: data.description,
      login: data.login,
      offline_image_url: data.offline_image_url,
      type: data.type,
      view_count: data.view_count,
      created_at: data.created_at
    }
  end

  def self.badges(username:)
    broadcaster_id = user(username:)[:id]
    twitch_client = client

    HTTParty.get(
      "https://api.twitch.tv/helix/chat/badges?broadcaster_id=#{broadcaster_id}",
      headers: {
        'Authorization' => "Bearer #{twitch_client.tokens.access_token}",
        'Client-Id' => CLIENT_ID
      }
    )
  end
end

# routes
get '/' do
  'vellicare OK'.to_json
end

get '/:username' do
  TwitchAPI.user(username: params['username']).to_json
end

get '/:username/badges' do
  TwitchAPI.badges(username: params['username']).to_json
end

not_found do
  p "Hmmm... can't find that"
end
