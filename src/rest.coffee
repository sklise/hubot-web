Robot = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
request = require('request')

# sendmessageURL domain.com/messages/new/channel/ + user.channel
sendMessageUrl = process.env.HUBOT_REST_SEND_URL

class Rest extends Adapter
  send: (user, strings...) ->
    if strings.length > 0
      request.post(sendMessageUrl+user.channel).form({
        message:(strings.shift()),
        from: user.user
      })
      @send user, strings...

  reply: (user, strings...) ->
    @send user, strings.map((str) -> "#{user.user}: #{str}")...

  run: ->
    self = @

    options = {}

    # console.log(@robot)

    # expect {message, from, options}
    @robot.router.post '/receive/:channel', (req, res) ->
      console.log req.params.channel, req.params, req.body.message
      res.setHeader 'content-type', 'text/html'
      self.receive new TextMessage({channel: req.params.channel, user:'test'}, req.body.message)
      res.end 'hi'

    self.emit "connected"

exports.use = (robot) ->
  new Rest robot