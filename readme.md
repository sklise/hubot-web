# Hubot Web Adapter

An adapter for [Hubot](https://github.com/github/hubot) to work via HTTP. Great for your custom web chat interface.

## Setup

Set `HUBOT_REST_SEND_URL` as an environment variable to send hubot responses to.

If you want Hubot responses to be formatted for HTML, currently replacing newlines with `<br>`s, set HUBOT_HTML_RESPONSE to true.

Also, if you're running hubot on Heroku, set your Procfile as a web process and not an app.