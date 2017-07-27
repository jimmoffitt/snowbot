class GenerateDirectMessageContent
	
	BOT_NAME = 'snowbot'
	BOT_CHAR = '❄'

	
	def generate_greeting

		greeting = "#{BOT_CHAR} Welcome to #{BOT_NAME} #{BOT_CHAR}"
		greeting

	end
	
	def generate_main_message
		greeting = ''
		greeting = generate_greeting
		greeting =+ ' Thanks for stopping by...'

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
		event['event'] = {}
		event['event']['type'] = 'message_create'
		event['event']['message_create'] = {}
		event['event']['message_create']['target'] = {}
		event['event']['message_create']['target']['recipient_id'] = "#{recipient_id}"

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

	def generate_system_info(recipient_id)

		message_text = "This is a snow bot... It's kinda simple, kinda not."

		#Build DM content.
		event = {}
		event['event'] = {}
		event['event']['type'] = 'message_create'
		event['event']['message_create'] = {}
		event['event']['message_create']['target'] = {}
		event['event']['message_create']['target']['recipient_id'] = "#{recipient_id}"

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

		message_text = "This system will support several commands. TBA. Like 'photo', 'link', and 'day'"

		#Build DM content.
		event = {}
		event['event'] = {}
		event['event']['type'] = 'message_create'
		event['event']['message_create'] = {}
		event['event']['message_create']['target'] = {}
		event['event']['message_create']['target']['recipient_id'] = "#{recipient_id}"

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
	
	def generate_link_list(recipient_id, list)

		event = {}
		event['event'] = {}
		event['event']['type'] = 'message_create'
		event['event']['message_create'] = {}
		event['event']['message_create']['target'] = {}
		event['event']['message_create']['target']['recipient_id'] = "#{recipient_id}"

		message_data = {}
		message_data['text'] = 'Select a link:'

		message_data['quick_reply'] = {}
		message_data['quick_reply']['type'] = 'options'

		options = []
		
		#NEEDS UPDATES TO LINK structure...

		list.each do |item|
			option = {}
			option['label'] = '💧 ' + item[0]
			option['metadata'] = "location_list_choice: #{item[0]}"
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
		event['event'] = {}
		event['event']['type'] = 'message_create'
		event['event']['message_create'] = {}
		event['event']['message_create']['target'] = {}
		event['event']['message_create']['target']['recipient_id'] = "#{recipient_id}"

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
		event['event'] = {}
		event['event']['type'] = 'message_create'
		event['event']['message_create'] = {}
		event['event']['message_create']['target'] = {}
		event['event']['message_create']['target']['recipient_id'] = "#{recipient_id}"

		message_data = {}
		message_data['text'] = 'Select your area of interest:'

		message_data['quick_reply'] = {}
		message_data['quick_reply']['type'] = 'options'

		options = []

		list.each do |item|
			option = {}
			option['label'] = '💧 ' + item
			option['metadata'] = "location_list_choice: #{item}"
			#Not including 'description' option attributes.
			options << option
		end

		message_data['quick_reply']['options'] = options

		event['event']['message_create']['message_data'] = message_data
		event.to_json

	end
	
	def build_custom_options

		options = []

		option = {}
		option['label'] = '❄ See snow picture ❄'
		option['description'] = 'come on, take a look'
		option['metadata'] = 'see_photo'
		quick_reply['options'] << option

		option = {}
		option['label'] = '❄ Suggest a snow day ❄'
		option['description'] = 'soon?'
		option['metadata'] = 'snow_day'
		quick_reply['options'] << option

		option = {}
		option['label'] = '❄ Read and learn about snow ❄'
		option['description'] = 'Other than it sometimes melts at > 32F'
		option['metadata'] = 'learn_snow'
		quick_reply['options'] << option

		option = {}
		option['label'] = '❄ Pick a favorite point/place on the globe ❄'
		option['description'] = 'Just curious.'
		option['metadata'] = 'pick_from_map'
		quick_reply['options'] << option
		
		option

		#option = {}
		#option['label'] = 'Ask Twitter API question!'
		#option['description'] = 'Ask a question, maybe get an answer...'
		#option['metadata'] = 'ask_gnip'
		#quick_reply['options'] << option
		
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
		option['metadata'] = "return_home"
		options << option
		
		options
		
		
	end


	def acknowledge_location(recipient_id, area_of_interest)
		#Build DM content.
		event = {}
		event['event'] = {}
		event['event']['type'] = 'message_create'
		event['event']['message_create'] = {}
		event['event']['message_create']['target'] = {}
		event['event']['message_create']['target']['recipient_id'] = "#{recipient_id}"

		message_data = {}
		message_data['text'] = "You have added an area of interest: #{area_of_interest}"
		#\n To select an additional area, send an 'Add' Direct Message.
    #  \n To review your current areas of interest, send a 'List' Direct Message.
    #  \n If you want to unsubscribe, send a 'Quit' or 'Stop' Direct Message." #'Unsubscribe' is also supported.

		message_data['quick_reply'] = {}
		message_data['quick_reply']['type'] = 'options'

		options = []
		#Not including 'description' option attributes.
		
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
		option['metadata'] = "return_home"
		options << option

		message_data['quick_reply']['options'] = options
		event['event']['message_create']['message_data'] = message_data
		event.to_json

	end
	
	def generate_message(recipient_id, message)

			message_text = message

			#Build DM content.
			event = {}
			event['event'] = {}
			event['event']['type'] = 'message_create'
			event['event']['message_create'] = {}
			event['event']['message_create']['target'] = {}
			event['event']['message_create']['target']['recipient_id'] = "#{recipient_id}"

			message_data = {}
			message_data['text'] = message_text

			event['event']['message_create']['message_data'] = message_data
			event.to_json
	end

end
