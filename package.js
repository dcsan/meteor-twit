Package.describe({
  "version": "0.0.1",
  "name": "dcsan:twit",
  "summary": "twit wrapper"
});

Npm.depends(
  {twit: "1.1.20"},
  {sleep: "2.0.0"}
);

Package.on_use(function (api) {

  // use client
  api.use([
    'coffeescript',
  ] );

  api.add_files([
    "main.js", 
    "lib/SavedTweets.coffee",
    "lib/Tbot.coffee"
  ], "server");

  // console.log("exporting Tbot", Tbot)
  api.export(['Twit', 'Tbot', 'SavedTweets'], ['client', 'server']);

});
