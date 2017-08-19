# snowbot
A snow bot, of course.

This is the second Twitter bot I've built. Code wise, this is an iteration on the [@FloodSocial bot](https://github.com/jimmoffitt/FloodSocial). That bot is a flood notification proof-of-concept app developed to learn the Account Activity and Direct Message APIs, and was first demoed at an early-warning conference in June 2017. That bot was thrown together to meet a conference dead-line, and some of the code reflects that: the 'event manager' class is like a run-on sentence, and the 'generate Direct Message content' code has lots of redundant code. So the Snowbot code represents an on-going clean-up of those types of issues. Still, the @FloodSocial demo worked out well and may have helped in receiving an 'innovation in hydrologic warning' conference award ;)

This bot is much more of a sandbox, and will evolve as new and different aspects of the AA and DM APIs are implemented in the bot. An example of this is that the snowbot serves (locally hosted) photos as DM media attachments. 

Basically a *snowbox* for experimenting and exploring...A playground for sending DMs with media and links, serving third-party weather and snow api data. 

## New twists:

* Baking in twitter gem. First needed for media uploads for attaching media to Direct Messages.

* Presenting and displaying currated URLs. A fundamental way to forward users to other web destinations. 
  * Serving up curated list of 'next step' URLs.
  * Serving up music playlists.
  
* Adding in third-party APIs.
  * Weather API for getting current weather conditions. Many to chose from, this demo is using http://api.wunderground.com/
  * Built in SnoCountry API: http://feeds.snocountry.net/
  
* When building a bot, you need tools to manage AA setup, AA subscriptions and default welcome messages.
  * Iterating on Account Activity API set-up and subscription script.
  * Iterating on DM default Welcome Message script.

* Supporting only environmental variables (ENV) for configuration and ripping out loading from config.yaml files. 
  * Deploying this on Heroku led to a switch from yaml config files to using system environmental variables.
  * Seems to have some nice advantages... less and hopefully clearer code, seems easier to protect authentication keys. 
  * If you are developing/testing/deploying on MacOs/Linux/Heroku at least, definitely recommend it. Windows is an unknown here, have not tested Ruby ENV on Windows, but image it is straightforward.
  * Inside IDE, it is kinda of a pain having some many configurations, each with its own ENV hive.
 
* Fundamental 'feature' is the display of a location list. If a bot needs to be geo-aware, and there are pre-determined locations of interest, then a mechanism to load a pre-configured list of locations is mandatory. 
  
  * Adding 'features' to the 'get resources' process. These resources are data files containing metadata for the bot, such as location lists to present to bot users. Basically these are CSV files that have values loaded into a Twitter DM Quick Reply.
  * Need to support file headers/comments.
  * I've built two bots now that serve up location lists, and they have been different in structure, a mix of common attributes and others unique to the bot. In @FloodSocial, the location list is made up of major Texas cities (roughly top 20 in population). With the snowbot, ski resorts are served up. Common attributes for these bots include location name, longitude and latitude.  In all cases these coordinates are based on the geographical center of the location list **places**. For the snowbot, a resort ID is also the configuration metadata. These IDs are needed when making requests of the snow report API. 
  
## Upcoming? 

* Providing 3-day forecast
* Port to a different demo account? 

  



