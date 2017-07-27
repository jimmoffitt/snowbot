require 'json'
require 'csv'
require_relative 'api_oauth_request'
require_relative 'generate_direct_message_content'

class SendDirectMessage

	attr_accessor :dm,            #Object that manages DM API requests.
	              :content,
	              :sender,
	              :location_list, #This class knows the configurable location list.
	              :link_list,
	              :image_list     #JPEGs for now. 

	def initialize

		#@dm = ApiRequest.new('../../config/accounts_private.yaml') #this context does not work within Sinatra app...?

		@dm = ApiOauthRequest.new

		@dm.uri_path = '/1.1/direct_messages'
		@dm.get_api_access

		@content = GenerateDirectMessageContent.new

		
		#Load menu resources:

		@location_list = []
		
		begin
			locations = CSV.read(File.join(APP_ROOT, 'data', 'placesOfInterest.csv'))
		rescue #Running outside of Sinatra?
			locations = CSV.read('../../data/placesOfInterest.csv')
		end

		locations.each do |location|
			@location_list << location[0] #Load just the location name.
		end

		@link_list = []

		begin
			links = CSV.read(File.join(APP_ROOT, 'data', 'links.dat'), { :col_sep => "\t" })
		rescue #Running outside of Sinatra?
			links = CSV.read('../../data/links.dat', { :col_sep => "\t" })
		end

		links.each do |link|
			@link_list << link[0] #Load just the location name.
		end


		@photo_list = []

		begin
			photos = "Load path of jpeg file."
		rescue #Running outside of Sinatra?
			photos = "Load path of jpeg file."
		end

		photos.each do |photo|
			@photo_list << photo[0] #Load just the location name.
		end
		
	end

	#TODO: this method is NOT currently used by 'set-up' webhook scripts...
	#New users will be served this.
	#https://dev.twitter.com/rest/reference/post/direct_messages/welcome_messages/new

	#Send a DM back to user.
	#https://dev.twitter.com/rest/reference/post/direct_messages/events/new
	def send_direct_message(message)
		
		uri_path = "#{@dm.uri_path}/events/new.json"
		response = @dm.make_post_request(uri_path, message)
  	#puts "Attempted to send #{message} to #{uri_path}/events/new.json"
	
		#Currently, not returning anything... Errors reported in POST request code.
		response

	end

	def send_welcome_message(recipient_id)
		dm_content = @content.generate_welcome_message(recipient_id)
		send_direct_message(dm_content)
	end
		
	def send_photo(recipient_id, name)
		dm_content = @content.generate_dm_media(recipient_id, name)
		send_direct_message(dm_content)
	end

	

	def send_map(recipient_id)
		dm_content = @content.generate_location_map(recipient_id)
		send_direct_message(dm_content)
	end
	
	
	# Sending multiple, different lists -------------------------------------

	def send_location_list(recipient_id)
		dm_content = @content.generate_location_list(recipient_id, @location_list)
		send_direct_message(dm_content)
	end

	def send_links(recipient_id)
		dm_content = @content.generate_link_list(recipient_id, @link_list)
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
	
end

if __FILE__ == $0 #This script code is executed when running this file.

	sender = SendDirectMessage.new
	sender.send_location_list(944480690)

	sender.send_map(944480690)

end