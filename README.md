# TEMPLATE

# abot
A bot, of course.

Feature list:
* Serve DMs with media
  * Baking in twitter gem. First needed for media uploads for attaching media to Direct Messages.
* Collect user location of interest via DM via two methods:
 * Serve map to user for specifying Place or exact location. 
 * Service location lists (major cities, snow resorts, store locations, etc.)
* Serving links to other sites
 * Serving up Spotify playlists.
 * Presenting and displaying currated URLs. 

* Adding in third-party APIs.
  * Weather API for getting current weather conditions.
  * Snow report API
* Configuration
  * Supporting only environmental variables (ENV) for configuration and ripping out loading from config.yaml files. 
    * Deploying this on Heroku led to a switch from yaml config files to using system environmental variables.
    * Seems to have some nice advantages... less and hopefully clearer code, removed command-line arg, seems easier to manage privacy concerns. 
    * If you are developing/testing/deploying on MacOs/Linux/Heroku at least, definitely recommend it. Windows is an unknown here, have not tested Ruby ENV on Windows, but image it is straightforward.
    * Inside IDE, it is kinda of a pain having some many configurations, each with its own ENV hive.

* Needed tools to manage AA setup and subscriptions and default welcome messages.
  * Iterating on Account Activity API set-up and subscription script.
  * Iterating on DM default Welcome Message script.


## Upcoming? 

* Providing 3-day forecast
* Build in ski reports. Need to find a free API that serves snow/resort reports. 
* Adding 'features' to the 'get resources' process. These resources are data files containing metadata for the bot, such as location lists to present to bot users. Basically these are CSV files that have values loaded into a Twitter DM Quick Reply.
  * Need to support file headers/comments.



