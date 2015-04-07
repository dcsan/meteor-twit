Twit = Npm.require('twit')
sleep = Npm.require('sleep')

randomRange = (min, max) ->
  return Math.floor(Math.random() * (max - min) + min)


class Tbot

  constructor: (@cfg) ->
    @twit = new Twit(@cfg)
    console.log("new TBot")

  get: (url, params, opts) ->
    params ?= {}
    @twit.get url, params, (err, data, response) =>
      if err
        console.error err
      else
        if opts.debug
          @log url, data

  post: (url, params, opts) ->
    params ?= {}
    @twit.post url, params, (err, data, response) =>
      if err
        console.error url, params
        console.error err
      else
        if opts.debug
          @log url, data

  log: (url, data, response) ->
    console.log("---------- #{url} ---------")
    console.log('data')
    console.log(JSON.stringify(data, null, 2))
    console.log('response')
    console.dir(response)
    console.log("--------------------------------------")


  replyMany: (opts) ->
    unless opts.query
      opts.query = "#twinglish"
      console.warn ("no query, using #{opts.query}")

    @twit.get 'search/tweets', {
      q: opts.query
      count: opts.count
    }, (err, data, response) =>
      if (err)
        console.error('saveTweets', err)
      else
        tweets = data.statuses
        console.log 'found tweets:', tweets.length
        i = 0
        for tweet in tweets
          tw = {
            'username': tweet.user.name
            'screen_name': tweet.user.screen_name
            'lang': tweet.user.lang
            'location': tweet.user.location
            "hashtags": tweet.entities.hashtags
            "entities": tweet.user.entities
            "urls": tweet.entities.urls
            'text': tweet.text
          }
          console.log("\n", tw)
          if opts.favorite
            @favorite(tweet)
          # @replyTo(tweet, opts.reply)
          @tweetAt(tweet.user.screen_name, opts.reply)
          @pause()

  pause: () ->
    s = randomRange(0,20*1000000)
    console.log('sleep', s)
    sleep.usleep(s)
    console.log('awake')


  replyTo: (tweet, msg) ->
    fullMsg = "@#{tweet.user.screen_name} #{msg}"
    opts = {
      status: fullMsg
      in_reply_to_status_id: tweet.id_str
    }
    console.log("replyTo\n", opts)
    @post 'statuses/update', opts

  favorite: (tweet) ->
    @post 'favorites/create', {id: tweet.id_str}

  tweetAt: (screen_name, status) ->
    status ?= "Did you play at ComicEnglish.com today?"
    screen_name ?= "noahcomice"
    fullMsg = "@#{screen_name} #{status}"
    console.log("tweetAt", fullMsg)
    @twit.post 'statuses/update', {
      status: fullMsg
    }, (err, data, response) =>
      if err
        console.error(err)
      else
        console.log("tweetAt", fullMsg, {debug: true})
      # console.log(data, response)

  followers: () ->
    @twit.get 'followers/list', {
    }, (err, data, response) =>
      console.log(data)

  settings: () ->
    @get 'account/settings'

  rate_limit_status: () ->
    @get('application/rate_limit_status', {}, {debug:true})
