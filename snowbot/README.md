# Building the Snowbot

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

## CRC Check

## Validate setup

```
Usage: setup_webhooks [options]
    -c, --config CONFIG              Configuration file (including path) that provides account OAuth details. 
    -t, --task TASK                  Securing Webhooks Task to perform: trigger CRC ('crc'), set config ('set'), list configs ('list'), delete config ('delete'), subscribe app ('subscribe'), unsubscribe app ('unsubscribe'),get subscription ('subscription').
    -u, --url URL                    Webhooks 'consumer' URL, e.g. https://mydomain.com/webhooks/twitter.
    -i, --id ID                      Webhook ID
    -h, --help                       Display this screen.
```




```
Usage: setup_welcome_message [options]
    -c, --config CONFIG              Configuration file (including path) that provides account OAuth details. 
    -w, --default WELCOME            Default Welcome Management: 'create', 'set', 'get', 'delete'
    -r, --rule RULE                  Welcome Message Rule management: 'create', 'get', 'delete'
    -i, --id ID                      Message or rule ID
    -h, --help                       Display this screen.
```



# Next Steps
+ To help you put all that information together, check out our [Twitter Direct Message API Playbook].
+ Twitter Webhook APIs https://dev.twitter.com/webhooks
+ Account Activity API documentation https://dev.twitter.com/webhooks/account-activity
+ Direct Message API methods: https://dev.twitter.com/rest/direct-messages
+ Read about another example bot. 







Configuring Twitter Webhooks


Webhook Setup

CRC Setup

Validate setup
