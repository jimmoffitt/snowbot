require_relative 'twitter_api'


class GenerateDirectMessageContent
	
	BOT_NAME = 'snowbot'
	BOT_CHAR = '❄'

	attr_accessor :TwitterAPI
	
	def initialize
		@twitter_api = TwitterAPI.new
		
	end

	def generate_greeting

		greeting = "#{BOT_CHAR} Welcome to #{BOT_NAME} #{BOT_CHAR}"
		greeting

	end
	
	def generate_main_message
		greeting = ''
		greeting = generate_greeting
		greeting =+ ' Thanks for stopping by... '

	end

	def message_create_header(recipient_id) 
		
		header = {}

		header['type'] = 'message_create'
		header['message_create'] = {}
		header['message_create']['target'] = {}
		header['message_create']['target']['recipient_id'] = "#{recipient_id}"
		
		header
		
	end
	

	#New users will be served this.
	#https://dev.twitter.com/rest/reference/post/direct_messages/welcome_messages/new
	def generate_welcome_message_default

		message = {}
		message['welcome_message'] = {}
		message['welcome_message']['message_data'] = {}
		message['welcome_message']['message_data']['text'] = generate_greeting

		message['welcome_message']['message_data']['quick_reply'] = generate_options_menu

		message.to_json

	end

	#Users are shown this after returning from 'show info' option... A way to serve to other 're-started' dialogs?
	#https://dev.twitter.com/rest/reference/post/direct_messages/welcome_messages/new
	def generate_welcome_message(recipient_id)

		event = {}
		event['event'] = message_create_header(recipient_id)

		message_data = {}
		message_data['text'] = generate_main_message

		message_data['quick_reply'] = generate_options_menu

		event['event']['message_create']['message_data'] = message_data

		event.to_json

	end

	#Users are shown this after returning from 'show info' option... A way to serve to other 're-started' dialogs?
	#https://dev.twitter.com/rest/reference/post/direct_messages/welcome_messages/new
	def generate_system_maintenance_welcome

		message = {}
		message['welcome_message'] = {}
		message['welcome_message']['message_data'] = {}
		message['welcome_message']['message_data']['text'] = "System going under maintenance... Come back soon..."

		message.to_json

	end

	#================================================================

	
	def generate_link_list(recipient_id, list)

		event = {}
		event['event'] = message_create_header(recipient_id)

		message_data = {}
		message_data['text'] = 'Select a link:'

		message_data['quick_reply'] = {}
		message_data['quick_reply']['type'] = 'options'

		options = []
		
		#TODO: NEEDS UPDATES TO LINK structure...

		list.each do |item|
			option = {}
			option['label'] = '❄ ' + item[0]
			option['metadata'] = "link_choice: #{item[0]}"
			#Not including 'description' option attributes.
			option['description'] = item[2]
			options << option
		end

		message_data['quick_reply']['options'] = options

		event['event']['message_create']['message_data'] = message_data
		event.to_json

	end
	
	
	#Generates Quick Reply for presenting user a Map via Direct Message.
	#https://dev.twitter.com/rest/direct-messages/quick-replies/location
	def generate_location_map(recipient_id)

		event = {}
		event['event'] = message_create_header(recipient_id)

		message_data = {}
		message_data['text'] = 'Select your area of interest from the map:'

		message_data['quick_reply'] = {}
		message_data['quick_reply']['type'] = 'location'
		message_data['quick_reply']['location'] = {}
		message_data['quick_reply']['location']['metadata'] = 'map_selection'

		event['event']['message_create']['message_data'] = message_data

		event.to_json
	end

	#Generates Qucik Reply for presenting user a Location List via Direct Message.
	#https://dev.twitter.com/rest/direct-messages/quick-replies/options
	def generate_location_list(recipient_id, list)

		event = {}
		event['event'] = message_create_header(recipient_id)

		message_data = {}
		message_data['text'] = 'Select your area of interest:'

		message_data['quick_reply'] = {}
		message_data['quick_reply']['type'] = 'options'

		options = []

		list.each do |item|
			option = {}
			option['label'] = '❄ ' + item
			option['metadata'] = "location_choice: #{item}"
			#Not including 'description' option attributes.
			options << option
		end

		message_data['quick_reply']['options'] = options

		event['event']['message_create']['message_data'] = message_data
		event.to_json

	end
	



	def acknowledge_location(recipient_id, area_of_interest)
		#Build DM content.
		
		#So, what to do with the location provided? 
		#@FloodSocial: Echo selection to user, show next steps.
		#@snowbot: Make a weather forecast API call? For now just extract coordinates and make a silly comment.
		
		response = "That's really interesting."
		
		event = {}
		event['event'] = message_create_header(recipient_id)

		message_data = {}
		message_data['text'] = "You indicated: #{area_of_interest}. /n #{response}"
		
		#\n To select an additional area, send an 'Add' Direct Message.
    #  \n To review your current areas of interest, send a 'List' Direct Message.
  
		message_data['quick_reply'] = {}
		message_data['quick_reply']['type'] = 'options'

		options = []
		#Not including 'description' option attributes.
		
		options = build_default_options
		
		message_data['quick_reply']['options'] = options
		event['event']['message_create']['message_data'] = message_data
		event.to_json

	end


	def generate_system_info(recipient_id)

		message_text = "This is a snow bot... It's kinda simple, kinda not. "

		#Build DM content.
		event = {}
		event['event'] = message_create_header(recipient_id)
		
		message_data = {}
		message_data['text'] = message_text

		message_data['quick_reply'] = {}
		message_data['quick_reply']['type'] = 'options'

		options = []

		option = {}
		option['label'] = '⌂ Home'
		option['metadata'] = "return_to_system"
		options << option

		message_data['quick_reply']['options'] = options

		event['event']['message_create']['message_data'] = message_data
		event.to_json
	end

	def generate_system_help(recipient_id)

		message_text = "This system will support several commands. TBD. Like 'photo', 'link', 'day', 'main', 'about'"

		#Build DM content.
		event = {}
		event['event'] = message_create_header(recipient_id)
		
		message_data = {}
		message_data['text'] = message_text

		message_data['quick_reply'] = {}
		message_data['quick_reply']['type'] = 'options'

		options = []
		#Not including 'description' option attributes.

		options = build_default_options

		message_data['quick_reply']['options'] = options

		event['event']['message_create']['message_data'] = message_data
		event.to_json
	end
	
	
	#=====================================================================================


	def build_custom_options

		options = []

		option = {}
		option['label'] = '❄ See snow picture ❄'
		option['description'] = 'come on, take a look'
		option['metadata'] = 'see_photo'
		options << option

		option = {}
		option['label'] = '❄ Suggest a snow day ❄'
		option['description'] = 'soon?'
		option['metadata'] = 'snow_day'
		options << option
	
		
		option = {}
		option['label'] = '❄ Read and learn about snow ❄'
		option['description'] = 'Other than it sometimes melts at > 32F'
		option['metadata'] = 'learn_snow'
		options << option

		option = {}
		option['label'] = '❄ Request a forecast for anywhere ❄'
		option['description'] = 'Exact location or Place centroid'
		option['metadata'] = 'pick_from_map'
		options << option

		option = {}
		option['label'] = '❄ Receive a "snow" song title ❄'
		option['description'] = '"Sounds good"'
		option['metadata'] = 'snow_day'
		options << option

		#option = {}
		#option['label'] = 'Ask Twitter API question!'
		#option['description'] = 'Ask a question, maybe get an answer...'
		#option['metadata'] = 'ask_gnip'
		#options << option

		options

	end


	def build_default_options

		options = []

		option = {}
		option['label'] = '❓ Learn more about this system'
		option['description'] = 'See a detailed system description and links to related information'
		option['metadata'] = 'learn_more'
		options << option

		option = {}
		option['label'] = '☔ Help'
		option['description'] = 'Help with system commands'
		option['metadata'] = 'help'
		options << option

		option = {}
		option['label'] = 'Home'
		option['description'] = 'Go back home'
		option['metadata'] = "return_home"
		options << option

		options

	end

	def generate_options_menu
		quick_reply = {}
		quick_reply['type'] = 'options'
		quick_reply['options'] = []

		custom_options = []
		custom_options = build_custom_options
		custom_options.each do |option|
			quick_reply['options'] << option
		end

		default_options = []
		default_options = build_default_options
		default_options.each do |option|
			quick_reply['options'] << option
		end

		quick_reply
	end


	def generate_message_with_media(recipient_id, message, photo)

		#Create Twitter ID for image content.

		media_id = @twitter_api.get_media_id(photo)
		puts "Generated media_id: #{media_id}"

		#Build DM content.
		event = {}
		event['event'] = message_create_header(recipient_id)

		message_data = {}
		message_data['text'] = message

		event['event']['message_create']['message_data'] = message_data

		#Build attachment metadata

		if media_id.nil?
			puts "Count not send photo: #{photo}"
			message_data['text'] = "Sorry, could not load photo: #{photo} ."
		else
			message_data['text'] = message

			attachment = {}
			attachment['type'] = "media"
			attachment['media'] = {}
			attachment['media']['id'] = media_id

			message_data['attachment'] = attachment
		end

		event.to_json

	end

	def generate_message(recipient_id, message)
		#Build DM content.
		event = {}
		event['event'] = message_create_header(recipient_id)

		message_data = {}
		message_data['text'] = message

		event['event']['message_create']['message_data'] = message_data

		event.to_json
	end



end
