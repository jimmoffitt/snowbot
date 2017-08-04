#POST requests to /webhooks/twitter arrive here.
#Twitter Account Activity API send events as POST requests with DM JSON payloads.

require 'json'
#Two helper classes... 
require_relative 'send_direct_message'

class EventManager
	@@previous_event_id = 0

	COMMAND_MESSAGE_LIMIT = 12	#Simplistic way to detect an incoming, short, 'commmand' DM.
	
	attr_accessor :DMsender

	def initialize
		puts 'Creating EventManager object'
		@DMSender = SendDirectMessage.new
	end

	def handle_quick_reply(dm_event)

		response = dm_event['message_create']['message_data']['quick_reply_response']['metadata']
		user_id = dm_event['message_create']['sender_id']

		puts "User #{user_id} answered with #{response}"

		#Default options
		if response == 'help'
			@DMSender.send_system_help(user_id)
		elsif response == 'learn_more'
			@DMSender.send_system_info(user_id)
		elsif response == 'return_home'
			puts "Returning to home in event manager...."
			@DMSender.send_welcome_message(user_id)
			
		#Custom options	
		elsif response == 'see_photo'
			@DMSender.send_photo(user_id)
		elsif response == 'snow_day'
			@DMSender.send_snow_day(user_id)
		elsif response == 'learn_snow'
			@DMSender.send_links(user_id)
		elsif response.include? 'link_choice'
			link_choice = response['link_choice: '.length..-1]
			@DMSender.respond_with_link(user_id, link_choice)
		elsif response.include? 'weather_info'
			@DMSender.respond_with_map(user_id)
		elsif response == 'map_selection'
			#Do we have a Twitter Place or exact coordinates....?
			location_type = dm_event['message_create']['message_data']['attachment']['location']['type']

			if location_type == 'shared_coordinate'
				coordinates = dm_event['message_create']['message_data']['attachment']['location']['shared_coordinate']['coordinates']['coordinates']
			else
				coordinates = dm_event['message_create']['message_data']['attachment']['location']['shared_place']['place']['centroid']
			end

			@DMSender.respond_with_weather_info(user_id, coordinates)
			
			
			
		#TODO - IMPLEMENT	------------------------------------------
		elsif response.include? 'snow_report'
			@DMSender.respond_with_resort_list(user_id)
		elsif response.include? 'resort_choice'
			
			location_choice = response['location_choice: '.length..-1]

			#Get coordinates
			coordinates = []

			location_choice = "#{location_choice} (centered at #{coordinates[0]}, #{coordinates[1]} to be specific)"
			@DMSender.respond_to_location_choice(user_id, location_choice)
		
		else #we have an answer to one of the above.
			puts "UNHANDLED user response: #{response}"
		end
		
	end

	def handle_command(dm_event)

		#Since this DM is not a response to a QR, let's check for other 'action' commands
		#puts 'Received a command/question DM? Need to track conversation stage?'

		request = dm_event['message_create']['message_data']['text']
		user_id = dm_event['message_create']['sender_id']
		
		puts "Request with command: #{request}"

		if request.length <= COMMAND_MESSAGE_LIMIT and (request.downcase.include? 'home' or request.downcase.include? 'main' or request.downcase.include? 'hello' or request.downcase.include? 'back')
			@DMSender.send_welcome_message(user_id)
		elsif request.length <= COMMAND_MESSAGE_LIMIT and (request.downcase.include? 'photo' or request.downcase.include? 'pic' or request.downcase.include? 'see')
			@DMSender.send_photo(user_id)
		elsif request.length <= COMMAND_MESSAGE_LIMIT and (request.downcase.include? 'learn')
			@DMSender.send_link(user_id)
		elsif request.length <= COMMAND_MESSAGE_LIMIT and (request.downcase.include? 'about')
			@DMSender.send_system_info(user_id)
		elsif request.length <= COMMAND_MESSAGE_LIMIT and (request.downcase.include? 'help')
			@DMSender.send_system_help(user_id)
		else
			#"Listen, I only understand a few commands like: learn, about, help"
		end
	end
	

	#responses are based on options' Quick Reply metadata settings.
	#pick_from_list, select_on_map, location list items (e.g. 'location_list_choice: Austin' or 'Fort Worth')
	#map_selection (triggers a fetch of the shared coordinates)

	def handle_event(events)

		#puts "Event handler processing: #{events}"

		events = JSON.parse(events)

		if events.key? ('direct_message_events')

			dm_events = events['direct_message_events']

			dm_events.each do |dm_event|

				if dm_event['type'] == 'message_create'

					#Is this a response? Test for the 'quick_reply_response' key.
					is_response = dm_event['message_create'] && dm_event['message_create']['message_data'] && dm_event['message_create']['message_data']['quick_reply_response']

					if is_response
						handle_quick_reply dm_event
					else
						handle_command dm_event
					end
				else
					puts "Hey a new, unhandled type has been implemented on the Twitter side."
				end
			end
		else
			puts "Received test JSON."
		end
	end
end
