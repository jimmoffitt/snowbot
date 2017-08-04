# Tutorial: Building a Snowbot

## Introduction

The purpose of this tutorial is to help developers get started with the Account Activity and Direct Message APIs.

The material below is split into several pieces. Much of the narrative is language-agnostic, and includes many code 
examples written in Ruby. Since these code examples are very short and have comments, we can consider them as pseudo-code. 
Pseudo-code that hopefully illustrates fundamental concepts that are readily applied to non-Ruby languages.



# Getting Started

As outlined [HERE](https://dev.twitter.com/webhooks/getting-started), here are the steps to take to set up access to and the 'plumbing' of the Account Activity API"


## Getting API access
+ Create a Twitter Application, and have it enabled with the Account Activity API. For now, you'll need to apply for Account Activity API access [HERE](https://gnipinc.formstack.com/forms/account_activity_api_configuration_request_form).

## Building webhook event consumer app
+ Deploy web app with an endpoint to handle incoming webhook events.
  + POST method that handles incoming Activity Account webhook events
  + GET method that implements CRC authentication requirements.
 
+ Subscribe your consumer web app using the Account Activity API
  + https://dev.twitter.com/webhooks/reference/post/account_activity/webhooks



+ Create a default Welcome Message 



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
 
 
 
 ### Implementing endpoints and routes
  
  
 ### Implementing CRC Check
 
 ### Validating setup



# Next Steps

+ To help you put all that information together, check out our [Twitter Direct Message API Playbook].
+ Twitter Webhook APIs https://dev.twitter.com/webhooks
+ Account Activity API documentation https://dev.twitter.com/webhooks/account-activity
+ Direct Message API methods: https://dev.twitter.com/rest/direct-messages
+ Read about another example bot. 



# Scripts for managing Account Activity API configuration


## Setting up webhooks

The setup_webooks.rb script helps automate Account Activity configuration management. https://dev.twitter.com/webhooks/managing

```
Usage: setup_webhooks [options]
    -c, --config CONFIG              Configuration file (including path) that provides account OAuth details. 
    -t, --task TASK                  Securing Webhooks Task to perform: trigger CRC ('crc'), set config ('set'), list configs ('list'), delete config ('delete'), subscribe app ('subscribe'), unsubscribe app ('unsubscribe'),get subscription ('subscription').
    -u, --url URL                    Webhooks 'consumer' URL, e.g. https://mydomain.com/webhooks/twitter.
    -i, --id ID                      Webhook ID
    -h, --help                       Display this screen.  
```


Here are some example commands:


  + setup_webhooks.rb -t "set" -u "https://snowbotdev.herokuapp.com/snowbot"
  
```
Setting a webhook configuration...
Created webhook instance with webhook_id: 890716673514258432 | pointing to https://snowbotdev.herokuapp.com/snowbot
```
  
If your web app is not running, or your CRC code is not quite ready, you will receive the following response:  
  
```
  Setting a webhook configuration...
error code: 400 #<Net::HTTPBadRequest:0x007ffe0f710f10>
{"code"=>214, "message"=>"Webhook URL does not meet the requirements. Please consult: https://dev.twitter.com/webhooks/securing"}
```  

  + setup_webhooks.rb -t "list"

```
Retrieving webhook configurations...
Webhook ID 890716673514258432 --> https://snowbotdev.herokuapp.com/snowbot
```

  + setup_webhooks.rb -t "delete" -i 883437804897931264 
  
```
Attempting to delete configuration for webhook id: 883437804897931264.
Webhook configuration for 883437804897931264 was successfully deleted.
```


### Adding Subscriptions to a Webhook ID

  + setup_webhooks.rb -t "subscribe" -i webhook_id
  
```
Setting subscription for 'host' account for webhook id: 890716673514258432
Webhook subscription for 890716673514258432 was successfully added.
```

  + setup_webhooks.rb -t "unsubscribe" -i webhook_id
  
```
Attempting to delete subscription for webhook: 890716673514258432.
Webhook subscription for 890716673514258432 was successfully deleted.
```

  + setup_webhooks.rb -t "subscription" -i webhook_id
  
```
Retrieving webhook subscriptions...
Webhook subscription exists for 890716673514258432.
```


### Triggering CRC check 

  + setup_webhooks.rb -t "crc"

```
Retrieving webhook configurations...
204
CRC request successful and webhook status set to valid.
```

If you receive a response saying the 'Webhook URL does not meet the requirements', make sure your web app is up and running. If you are using a cloud platform, make sure your app is not hibernating. 

```
Retrieving webhook configurations...
Too Many Requests  - Rate limited...
error: #<Net::HTTPTooManyRequests:0x007fc4239c1190>
{"errors":[{"code":88,"message":"Rate limit exceeded."}]}
Webhook URL does not meet the requirements. Please consult: https://dev.twitter.com/webhook/security
```

If you receive this message you'll need to wait to retry. The default rate limit is one request every 15 minutes. 

require 'bundler'
Bundler.require

require File.expand_path('../snowbot/config/environment',  __FILE__)

run SnowBotApp



## Setting up Welcome Messages

* *set_welcome_messages.rb* script that makes requests to the Twitter Direct Message API. 
* Takes one or two command-line parameters. 

```
Usage: setup_welcome_message [options]
    -w, --default WELCOME            Default Welcome Management: 'create', 'set', 'get', 'delete'
    -r, --rule RULE                  Welcome Message Rule management: 'create', 'get', 'delete'
    -i, --id ID                      Message or rule ID
    -h, --help                       Display this screen.
```

-w "create"

```
Creating Welcome Message...
error code: 403 #<Net::HTTPForbidden:0x007ff29903f230>
Errors occurred.
{"code"=>151, "message"=>"There was an error sending your message: Field description is not present in all options."}
```



setup_welcome_message --w "set" -i 883450462757765123


<What the story here? when one option did not have a description, this error is triggered:>





setup_welcome_message -w "delete" -i 883450462757765123

```
Deleting Welcome Message with id: 883450462757765123.
Deleted message id: 883450462757765123
```

-w "get"

```
Getting welcome message list.
Message IDs: 
Message ID 890789035756503044 with message: ❄ Welcome to snowbot ❄ 
Message ID 893578135685406724 with message: ❄ Welcome to snowbot ❄ 
Message ID 893579774534209539 with message: ❄ Welcome to snowbot (ver. 0.02) ❄ 
```

Here we see some debris... The one with the versioned message is the current one, and the other two are early ones that can be deleted. Note that there are common use-cases where you need multiple welcome messages, such as a 'under maintenance' message. This is not such a use-case, so let's go ahead and delete the unwanted welcome messages.

-w "delete" -i 890789035756503044

```
Deleting Welcome Message with id: 890789035756503044.
Deleted message id: 890789035756503044
```
-w "delete" -i 893578135685406724

```
Deleting Welcome Message with id: 893578135685406724.
Deleted message id: 893578135685406724
```

If you try to delete an unexisting Welcome Message ID: 

-w "get"

```
Getting welcome message list.
Message IDs: 
Message ID 893579774534209539 with message: ❄ Welcome to snowbot (ver. 0.02) ❄ 
```

### Setting the default Welcome Message

-r "get"

```
Getting welcome message rules list.
No rules exist.
```
-w "set" -i 874335750661263365


-r "delete" -i 870397618781691904

## Validate setup
