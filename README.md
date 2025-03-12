# Vellicare

A small TwitchAPI microservice that services [Loqui](https://github.com/johnakers/loqui)

### Endpoints

```
GET /:username
GET /:username/badges
GET /:username/emotes
```

### Notes

- Leverages [mauricew's ruby-twitch-api gem](https://github.com/mauricew/ruby-twitch-api)
- Leverages [Twitch's Badges API](https://dev.twitch.tv/docs/api/reference/#get-channel-chat-badges)
- Leverages [sinatra/cross_origin](https://github.com/britg/sinatra-cross_origin)
- [Helpful Sinatra note](https://github.com/sinatra/sinatra/issues/589)
