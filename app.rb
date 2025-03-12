# require 'dotenv/load'
# require 'pry'

require 'sinatra'
require 'sinatra/cross_origin'
require 'twitch-api'
require 'httparty'

# cors
configure do
  enable :cross_origin
end

options "*" do
  response.headers['Allow'] = 'HEAD,GET,PUT,POST,DELETE,OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'

  200
end

# api
class TwitchAPI
  CLIENT_ID = ENV['TWITCH_CLIENT_ID'].freeze
  CLIENT_SECRET = ENV['TWITCH_CLIENT_SECRET'].freeze

  attr_reader :client

  def initialize
    tokens = TwitchOAuth2::Tokens.new(
      client: {
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET
      }
    )

    @client = Twitch::Client.new(tokens:)
  end

  def user(username:)
    data = client.get_users({ login: username }).data.first

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

  def badges(username:)
    broadcaster_id = user(username:)[:id]

    HTTParty.get(
      "https://api.twitch.tv/helix/chat/badges?broadcaster_id=#{broadcaster_id}",
      headers: {
        'Authorization' => "Bearer #{client.tokens.access_token}",
        'Client-Id' => CLIENT_ID
      }
    )
  end
end

# routes
get '/:username' do
  headers "Access-Control-Allow-Origin" => "*"
  TwitchAPI.new.user(username: params['username']).to_json
end

get '/:username/badges' do
  headers "Access-Control-Allow-Origin" => "*"
  TwitchAPI.new.badges(username: params['username']).to_json
end

get '/:username/emotes' do
  headers "Access-Control-Allow-Origin" => "*"
  # Not Implemented... yet
  204
end

get '/' do
  headers "Access-Control-Allow-Origin" => "*"
  { vellicare: 'OK' }.to_json
end

not_found do
  404
end
