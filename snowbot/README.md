# Snowbot

## Recent updates, things in motion, and future dreams

* Iterated 'generate content' class without much testing so far. Mainly code clean-up... like common JSON headers. 
* Going with all ENV configuration, and eliminating confile.yaml files. 
* Adding quick_rely DMs with photos.
* Added wrapper to twitter gem.
* Built 'third-party' api class that so far just manages a geo-specific call to WeatherUnderground.

* TODO:
  * weather, current and forecast APIs (started)
  * snow, resort reports (still looking for a free api to try).
  * launch curated Spotify playlist?
  
 ## Notes
  
 ### Configuring and hosting photos...
 
 There are two pieces: 
 * images files in /app/config/data/photos/ [photos_home]
 * photos.csv file - CSV file with image file name, and caption.
   * Image file names, all of which should correspond to a file in [photos_home].
   * Missing captions are OK.
  
 ### Common errors:
 
 Building Welcome Messages: 
 
 * Account associated with AA/DM app must allow Direct Messages (dms) from all accounts. 
 Error 400 
 "{"errors":[{"code":214,"message":"owner must allow dms from anyone"}]}"
  
 * option['label'] = '❄ Learn something new about snow ❄ - TOO LONG'
  Error 403
 "{"errors":[{"code":151,"message":"There was an error sending your message: Field label's display length exceeds maximum length of 36."}]}"
 

 


