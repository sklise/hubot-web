Robot = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
request = require('request')

# sendmessageURL domain.com/messages/new/channel/ + user.channel
sendMessageUrl = process.env.HUBOT_REST_SEND_URL

class RestAdapter extends Adapter

  createUser: (username, room) ->
    user = @userForName username
    unless user?
      id = new Date().getTime().toString()
      user = @userForId id
      user.name = username

    user.room = room

    user

  send: (user, strings...) ->
    if strings.length > 0
      request.post(sendMessageUrl+user.room).form({
        message:(strings.shift()),
        from: "#{@robot.name}"
      })
      @send user, strings...

  reply: (user, strings...) ->
    @send user, strings.map((str) -> "#{user.user}: #{str}")...

  run: ->
    self = @

    options = {}

    @robot.router.post '/receive/:room', (req, res) ->
      user = self.createUser(req.body.from, req.params.room)

      res.setHeader 'content-type', 'text/html'
      self.receive new TextMessage(user, req.body.message)
      res.end 'received'

    self.emit "connected"

exports.use = (robot) ->
  new RestAdapter robot