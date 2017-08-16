# snowbot
A snow bot, of course.

This is the second Twitter bot I've built. Code wise, this is an iteration on the [@FloodSocial bot](https://github.com/jimmoffitt/FloodSocial). That bot is a flood notification proof-of-concept app developed to learn the Account Activity and Direct Message APIs, and was first demoed at an early-warning conference in June 2017.

This bot is much more of a sandbox, and will evolve as new and different aspects of the AA and DM APIs are implemented in the bot. An example of this is that the snowbot serves (locally hosted) photos as DM media attachments. 

Basically a snowbox for experimenting and exploring...A playground for sending DMs with media and links, serving third-party weather and snow api data. 

## New twists:

* Baking in twitter gem. First needed for media uploads for attaching media to Direct Messages.

* Adding in first third-party API.
  * Weather API for getting current weather conditions.

* Needed tools to manage AA setup and subscriptions and default welcome messages.
  * Iterating on Account Activity API set-up and subscription script.
  * Iterating on DM default Welcome Message script.

* Supporting only environmental variables (ENV) for configuration and ripping out loading from config.yaml files. 
  * Deploying this on Heroku led to a switch from yaml config files to using system environmental variables.
  * Seems to have some nice advantages... less and hopefully clearer code, removed command-line arg, seems easier to manage privacy concerns. 
  * If you are developing/testing/deploying on MacOs/Linux/Heroku at least, definitely recommend it. Windows is an unknown here, have not tested Ruby ENV on Windows, but image it is straightforward.
  * Inside IDE, it is kinda of a pain having some many configurations, each with its own ENV hive.
  
  * Presenting and displaying currated URLs. 
  
  * Serving up Spotify playlists.
  
## Upcoming? 

* Providing 3-day forecast
* Build in ski reports. Need to find a free API that serves snow/resort reports. 
* Adding 'features' to the 'get resources' process. These resources are data files containing metadata for the bot, such as location lists to present to bot users. Basically these are CSV files that have values loaded into a Twitter DM Quick Reply.
  * Need to support file headers/comments.



