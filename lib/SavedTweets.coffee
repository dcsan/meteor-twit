if Meteor.isServer
  SavedTweets = new Meteor.Collection "SavedTweets"
  console.log("defined SavedTweets")