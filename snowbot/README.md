# Snowbot

## Recent updates, things in motion, and future dreams

* Iterated 'generate content' class without much testing so far. Mainly code clean-up... like common JSON headers. 
* Going with all ENV configuration, and eliminating confile.yaml files. 
* Adding quick_rely DMs with photos.
* Added wrapper to twitter gem.
* Built 'third-party' api class that so far just manages a geo-specific call to WeatherUnderground.

* TODO:
  * weather, current and forecast APIs (started)
  * snow, resort reports (still looking for a free api to try). Plan on experimenting with http://feeds.snocountry.net/.
  * launch curated Spotify playlist?
  
 ## Notes
  
 ### Configuring and hosting photos...
 
 There are two pieces: 
 * images files in /app/config/data/photos/ [photos_home]
 * photos.csv file - CSV file with image file name, and caption.
   * Image file names, all of which should correspond to a file in [photos_home].
   * Missing captions are OK.
  
  
 ### Spotify notes
 GET https://api.spotify.com/v1/users/{user_id}/playlists/{playlist_id}
 
 https://developer.spotify.com/web-api/user-guide/#spotify-uris-and-ids
 ```
 The base-62 identifier that you can find at the end of the Spotify URI (see above) for an artist, track, album, playlist, etc. Unlike a Spotify URI, a Spotify ID does not clearly identify the type of resource; that information is provided elsewhere in the call.
 ```
 
 ### Common errors:
 
 Building Welcome Messages: 
 
 * Account associated with AA/DM app must allow Direct Messages (dms) from all accounts. 
 Error 400 
 "{"errors":[{"code":214,"message":"owner must allow dms from anyone"}]}"
  
 * option['label'] = '❄ Learn something new about snow ❄ - TOO LONG'
  Error 403
 "{"errors":[{"code":151,"message":"There was an error sending your message: Field label's display length exceeds maximum length of 36."}]}"
 
 * Error code: 403 #<Net::HTTPForbidden:0x007f979302fc38>
Error Message: {"errors":[{"code":151,"message":"There was an error sending your message: Invalid QuickReply field description containing url(s)."}]}

* Error code: 400 #<Net::HTTPBadRequest:0x00000003848cf0> 
Error Message: {"errors":[{"code":214,"message":"event.message_create.message_data: Neither text or attachment defined on message_data"}]}  

* Error code: 403 #<Net::HTTPForbidden:0x0000000354f418> 
Error Message: {"errors":[{"code":151,"message":"There was an error sending your message: Field description is empty."}]} 


