# Tutorial: Building the snowbot
#### Tags: DMAPI, AAAPI, Ruby, WebApp, Sinatra

# Introduction
The purpose of this tutorial is to help developers get started with the Twitter Account Activity and Direct Message APIs. The material below is split into several pieces. Much of the narrative is language-agnostic, yet includes many code examples written in Ruby. Since these code examples are very short and have comments, we can consider them as pseudo-code. Pseudo-code that hopefully illustrates fundamental concepts that are readily implemented in non-Ruby languages.

We'll start off with a how to get started with these APIs. The steps here include getting access keys to the APIs, and deploying a web app that integrates both APIs. By integrating with the Account Activity (AA) API you are developing a consumer of webhook events sent from Twitter. By integrating the Direct Message (DM) API, you are building the private communication channel to your bot users. The AA API prodives the ability to listen for Twitter account activities, and the DM API enables you to send messages back to your users. 

# Getting Started
As outlined [HERE](https://dev.twitter.com/webhooks/getting-started), here are the steps to take to set up access to, and the 'plumbing' of, the Account Activity API.

## Getting API access
+ Create a Twitter Application, and have it enabled with the Account Activity API. For now, you'll need to apply for Account Activity API access [HERE](https://gnipinc.formstack.com/forms/account_activity_api_configuration_request_form).

## Building webhook event consumer app
[Intro to why these scripts are needed and an overview of how/when used. "As a AA API client, I need to a tool to update my default Welcome Message. I need to set one up to get started, and also will update it as my bot evolves and add new features.] 

+ Deploy web app with an endpoint to handle incoming webhook events.
  + POST method that handles incoming Activity Account webhook events
  + GET method that implements CRC authentication requirements.
 
+ Subscribe your consumer web app using the Account Activity API
  + https://dev.twitter.com/webhooks/reference/post/account_activity/webhooks

+ Create a default Welcome Message.

+ Handle CRC event.



==========================================

# Building web app

This web app was built using the [sinatra] web framework. This web app runs on a server deployed by the developer. This 
project is currently deployed on heroku, and should readily work on other cloud platforms. The web app we are building 
here is the connection between the Snowbot and Twitter.  
 
This web app, as currently designed, has a few fundamental responsibilities:

+ Receive Twitter Account Activity webhook Direct Message events. These webhook events alert 
this app when any of 'its' accounts receive a Direct Message. 
+ Assess incoming Direct Message and manage any responses. Decide between:
  + Quick Reply response
  + Bot command
  + Non-Bot targeted, so a pass-through 
+ Send Direct Message back to user.
   
   
 ## Building Account Activity API client
 
 ```ruby
 
require 'sinatra'

class SnowBotApp < Sinatra::Base

  def initialize
    super()
  end
  
  //Add routes, methods, etc.

end
 
 ```
 
 
 ### Implementing endpoints and routes
  
```ruby
require 'sinatra'
require_relative "../../app/helpers/event_manager"

class SnowBotApp < Sinatra::Base

  def initialize
    super()
  end

  get '/' do
    "<p><b>Welcome to the snow bot...</b></p>
  end
  
  # Receives DM events.
  post '/snowbot' do
    request.body.rewind
    events = request.body.read
    manager = EventManager.new
    manager.handle_event(events)
    status 200
  end
end
```
  
  
  
### Implementing CRC Check
 
[Link to docs]

[Notes? Narrative]
While developing this code, you need to trigger a CRC check from Twitter. This is done by sending a PUT command to the AA endpoint and sending in your encypted consumer key. 

When developing this code, it took some patience since the AA endpoint had a rate minute of 1 request every 15 minutes. Unless you get your code working on the first try (I did not), you'll have to wait 15 minutes before retrying. For that reason it is a great idea to at least validate the format and structure of your CRC trigger request before calling the AA endpoint. (link to tester?)
 
```ruby
def generate_crc_response(consumer_secret, crc_token)
  hash = OpenSSL::HMAC.digest('sha256', consumer_secret, crc_token)
  return Base64.encode64(hash).strip!
end
```
 
```ruby
# Receives challenge response check (CRC).
get '/snowbot' do
  crc_token = params['crc_token']
  response = {}
  response['response_token'] = "sha256=#{generate_crc_response(settings.dm_api_consumer_secret, crc_token)}"
  body response.to_json
  status 200
end
```
  
 ### Validating web app setup
 
Deploy and test. Hit home page, and trigger a CRC check. At a minumum stub in your event manager and confirm you are receiving expected DM (and other) events. 

[Notes on any other points? This is a stage where setting up endpoint and subscriptions happens, as well as iterating on the default welecome message. Intro to next section.]

[Link to SEPARATE helper scripts? Link to Node examples too]
This doc explains why those are needed, but does not detail features and how to use.]

# Next Steps

+ To help you put all that information together, check out our [Twitter Direct Message API Playbook].
+ Twitter Webhook APIs https://dev.twitter.com/webhooks
+ Account Activity API documentation https://dev.twitter.com/webhooks/account-activity
+ Direct Message API methods: https://dev.twitter.com/rest/direct-messages
+ Read about another example bot. 


