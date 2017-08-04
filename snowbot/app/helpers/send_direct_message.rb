require 'json'
require 'csv'
require 'pathname'
require_relative 'api_oauth_request'
require_relative 'generate_direct_message_content'

class SendDirectMessage

	attr_accessor :dm,            #Object that manages DM API requests.
	              :content,
	              :sender

	def initialize

		puts "Creating SendDirectMessage object."
		
		@dm = ApiOauthRequest.new

		@dm.uri_path = '/1.1/direct_messages'
		@dm.get_api_access

		@content = GenerateDirectMessageContent.new

	end

	def send_snow_day(recipient_id)
		#Demonstrates easy way to stub out future functionality until customer 'generate content' method is written.
		message = "We should make that happen... (and I should write more code for continuing that dialog)"
		dm_content = @content.generate_message(recipient_id, message)
		send_direct_message(dm_content)
	end
	
	def send_photo(recipient_id)
		dm_content = @content.generate_random_photo(recipient_id)
		send_direct_message(dm_content)
	end
	
	def send_map(recipient_id)
		dm_content = @content.generate_location_map(recipient_id)
		send_direct_message(dm_content)
	end

	def send_links(recipient_id)
		dm_content = @content.generate_link_list(recipient_id, @link_list)
		send_direct_message(dm_content)
	end
	
	def send_location_list(recipient_id)
		dm_content = @content.generate_location_list(recipient_id, @location_list)
		send_direct_message(dm_content)
	end
	
	def respond_with_link(user_id, link_choice)
		dm_content = @content.send_link(recipient_id, link_choice)
		send_direct_message(dm_content)
	end

	def respond_with_weather_info(user_id, coordinates)
		dm_content = @content.generate_weather_info(recipient_id, coordinates)
		send_direct_message(dm_content)
	end
	
	# App Generic? All apps have these by default?

	def send_system_info(recipient_id)
		dm_content = @content.generate_system_info(recipient_id)
		send_direct_message(dm_content)
	end
	
	def send_system_help(recipient_id)
		dm_content = @content.generate_system_help(recipient_id)
		send_direct_message(dm_content)
	end

	def send_status(recipient_id, message)
		dm_content = @content.generate_message(recipient_id, message)
		send_direct_message(dm_content)
	end

	def send_welcome_message(recipient_id)
		dm_content = @content.generate_welcome_message(recipient_id)
		send_direct_message(dm_content)
	end

	#Send a DM back to user.
	#https://dev.twitter.com/rest/reference/post/direct_messages/events/new
	def send_direct_message(message)

		uri_path = "#{@dm.uri_path}/events/new.json"
		response = @dm.make_post_request(uri_path, message)
		#puts "Attempted to send #{message} to #{uri_path}/events/new.json"

		#Currently, not returning anything... Errors reported in POST request code.
		response

	end

end

#And here you can unit test sending different types of DMs... send map? attach media?

if __FILE__ == $0 #This script code is executed when running this file.

	sender = SendDirectMessage.new
	#sender.send_map(944480690)
	sender.send_photo(944480690)

end