# Hubot

This is a version of GitHub's bot, hubot. He's pretty cool. We run him on Hipchat.

This version is designed to be deployed on [Heroku][heroku].

[heroku]: http://www.heroku.com

## Playing with Apollos

You'll need to install the necessary dependencies for hubot. All of
those dependencies are provided by [npm][npmjs].

[npmjs]: http://npmjs.org

## HTTP Listener

Hubot has a HTTP listener which listens on the port specified by the `PORT`
environment variable.

You can specify routes to listen on in your scripts by using the `router`
property on `robot`.

```coffeescript
module.exports = (robot) ->
  robot.router.get "/hubot/version", (req, res) ->
    res.end robot.version
```

There are functions for GET, POST, PUT and DELETE, which all take a route and
callback function that accepts a request and a response.

## Redis

If you are going to use the `redis-brain.coffee` script from `hubot-scripts`
you will need to add the Redis to Go addon on Heroku which requires a verified
account or you can create an account at [Redis to Go][redistogo] and manually
set the `REDISTOGO_URL` variable.

    % heroku config:add REDISTOGO_URL="..."

If you don't require any persistence feel free to remove the
`redis-brain.coffee` from `hubot-scripts.json` and you don't need to worry
about redis at all.

[redistogo]: https://redistogo.com/

## Testing Hubot Locally

You can test your hubot by running the following.

    % bin/hubot

You'll see some start up output about where your scripts come from and a
prompt.

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/src/scripts
    Hubot>

Then you can interact with hubot by typing `hubot help`.

    Hubot> hubot help

    Hubot> animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that Hubot knows about.
    ...

Take a look at the scripts in the `./scripts` folder for examples.
Delete any scripts you think are silly.  Add whatever functionality you
want hubot to have.

## HipChat Variables

If you are using the [HipChat](https://github.com/hipchat/hubot-hipchat) adapter you will need to set some environment
variables. Refer to the documentation for other adapters and the configuraiton
of those, links to the adapters can be found on the [hubot wiki][hubot-wiki].

Create a separate HipChat user for your bot. Set the JID to the "Jabber ID" shown on your bot's [XMPP/Jabber account settings](https://www.hipchat.com/account/xmpp):

    % heroku config:add HUBOT_HIPCHAT_JID="..."

Set the password to the password chosen when you created the bot's account.

    % heroku config:add HUBOT_HIPCHAT_PASSWORD="..."

[hubot-wiki]: https://github.com/github/hubot/wiki

## Restart the bot

You may want to get comfortable with `heroku logs` and `heroku restart`
if you're having issues.

