# Hubot

This is a version of GitHub's bot, Hubot. He's pretty cool. We run him on Hipchat. This version is designed to be deployed on [Heroku][heroku].
[heroku]: http://www.heroku.com
## Redis

If you are going to use the `redis-brain.coffee` script from `hubot-scripts`
you will need to add the Redis to Go addon on Heroku which requires a verified
account or you can create an account at [Redis to Go][redistogo] and manually
set the `REDISTOGO_URL` variable.

```
$ heroku config:add REDISTOGO_URL="..."
```

If you don't require any persistence feel free to remove the
`redis-brain.coffee` from `hubot-scripts.json` and you don't need to worry
about redis at all.

[redistogo]: https://redistogo.com/

## HipChat Variables

If you are using the [HipChat](https://github.com/hipchat/hubot-hipchat) adapter you will need to set some environment
variables. Refer to the documentation for other adapters and the configuraiton
of those, links to the adapters can be found on the [hubot docs][https://hubot.github.com/docs/].

Create a separate HipChat user for your bot. Set the JID to the "Jabber ID" shown on your bot's [XMPP/Jabber account settings](https://www.hipchat.com/account/xmpp):
```
$ heroku config:add HUBOT_HIPCHAT_JID="..."
```
Set the password to the password chosen when you created the bot's account.
```
$ heroku config:add HUBOT_HIPCHAT_PASSWORD="..."
```
## Running Locally

Clone down this repo and run `npm i` and make sure all dependencies are installed correctly.

At this point you should be able to run `./bin/hubot` from inside the directory. This will start up hubot with the shell adapter and you should be able to give him some basic commands.

Naturally, you might want to test the integration of a particular script. This might require some credentials which need to be loaded into hubot. You have to option of specifying these on the command line like:

```
$ export HUBOT_AUTH_ADMIN=1
```

But doing that every time you load a new shell could get tedious. The recommended route is to install the [heroku-config](https://github.com/ddollar/heroku-config.git) plugin which will give you the command: **You must have access to the application in heroku in order to do this. You can also create a `.env` file to add your own keys and these instructions will still work.**
```
$ heroku config:pull
```
This pulls down all the config variables that are set in heroku and writes them to a `.env` file in the directory. **Note: This file is ignored in the repo ON PURPOSE. Please do not remove it from the .gitignore file.**

Once you have that installed you can run `source .env && ./bin/hubot` to load all the environment variables or use a tool like [forego](https://github.com/ddollar/forego) to utilize the Procfile in this directory.

## Writing Your Own Scripts

**Any and ALL work should be done on a separate branch and a pull request made. No exceptions.**

There are two ways you can write scripts for hubot. If the script is simple enough but not likely to be useful to anyone else you can add it in the `/scripts` directory and hubot will load it automatically when the application is started. Make sure you add any dependencies you need to the `package.json` file.

The alternative (preferred) way is create an npm package which will contain all the dependencies and source code to run. This method is preferred because it only requires you to add the package as a dependency in the	`package.json` file and the name to `external-scripts.json` directory. The package can have its own SCM repository and you can publish the package to npmjs.com.

To start your package, just create a new directory with the package name and run `npm init` inside the directory. This will create a `package.json` file. After you write some code you can use npm to link your new script into your working hubot install.
```
$ cd hubot-example
$ npm link
$ cd hubot
$ npm link hubot-example
```
Add `hubot-example` to the array in the `external-scripts.json` file and start up hubot. Once your script is ready for production, make sure you add it to the `package.json` file before its deployed. To see a simple example reference the [hubot-http-status](http://github.com/hubot-scripts/hubot-http-status) repo.

## Heroku

Hubot is hosted on heroku but you do not need access to the application to write your own scripts. If you would like to be able to pull down the config from heroku let someone with access know so they can add you.

LICENSE
-------

See the [Hubot](https://github.com/github/hubot/blob/master/LICENSE.md) LICENSE file.
