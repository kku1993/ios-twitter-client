ios-twitter-client
==========================

A simple iOS client for Twitter.

Total Time Spent: 10 hours

Completed User Stories:
- User can sign in using OAuth login flow
- User can view last 20 tweets from their home timeline
- The current signed in user will be persisted across restarts
- In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp
- User can pull to refresh
- User can compose a new tweet by tapping on a compose button.
- User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

# Installation
- Clone the project
- Install dependencies using CocoaPods

  `` pod install ``
    
- Modify ``TwitterClient/config.template.plist`` by inserting your own Twitter API key and renaming the file to ``config.plist``.

# Walkthrough
![Video Walkthrough](https://raw.githubusercontent.com/kku1993/ios-twitter-client/walkthroughs/walkthrough.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

# Libraries Used
- [AFNetworking](http://afnetworking.com/)
- [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
- [MMProgressHUD](https://github.com/mutualmobile/MMProgressHUD)

# Icons
- [Icons8](http://icons8.com)
