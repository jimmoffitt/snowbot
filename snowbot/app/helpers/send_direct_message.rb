require 'json'
require 'csv'
require 'pathname'
require_relative 'api_oauth_request'
require_relative 'generate_direct_message_content'

class SendDirectMessage

	attr_accessor :dm,            #Object that manages DM API requests.
	              :content,
	              :sender,

	              #Key feature design details: 
	              #  Supports a single list of locations 
	              #  Supports the look-up for a single list of links
	              #  Supports a single directory of JPEGs.
	              
	              :location_list, #This class knows the configurable location list.
	              :link_list,
	              :photo_list     #JPEGs for now.

	def initialize

		puts "Creating SendDirectMessage object."
		
		@dm = ApiOauthRequest.new

		@dm.uri_path = '/1.1/direct_messages'
		@dm.get_api_access

		@content = GenerateDirectMessageContent.new

		#Load menu resources:
		@photo_list = []

		begin
			
			#Kludgy I am sure. These photos are stored on backend and only served via DM.
			#TODO - Testing
			
			here = File.dirname(__FILE__)
			
			puts "__FILE__ set to: #{here}"
			
			there = File.expand_path('../../config/data/photos')
			
			relative = there.relative_path_from here
			puts "PHOTO FOLDER? #{here + relative}"

			photo_dir = ".#{here}#{relative}"

			photo_dir - '/app/snowbot/config/data/photos'
			
			puts "photo folder: #{photo_dir}"


			test_file = '../config/data/photos/corduroy.jpg'
			found = File.file?(test_file)
			if found
				puts "FOUND #{test_file}"
			end

			test_file = '../../config/data/photos/corduroy.jpg'
			found = File.file?(test_file)
			if found
				puts "FOUND #{test_file}"
			end

			test_file = '/app/snowbot/config/data/photos/corduroy.jpg'
			found = File.file?(test_file)
			if found
				puts "FOUND #{test_file}"
			end

		rescue #Running outside of Sinatra?
			photo_dir = '/app/snowbot/config/data/photos'
		end
		
		#Load photo files into array.
		photo_files = Dir.glob("#{photo_dir}/*.{jpg,JPG}")

		photo_files.each do |photo_file|
			@photo_list << photo_file #Load just the location name.
		end
		
		puts "Have a list of #{@photo_list.count} photos..."


		#@location_list = []

		#begin
		#	locations = CSV.read(File.join(APP_ROOT, 'config', 'data', 'locations', 'placesOfInterest.csv'))
		#rescue #Running outside of Sinatra?
		#	locations = CSV.read('../../config/data/locations/placesOfInterest.csv')
		#end

		#locations.each do |location|
		#	@location_list << location[0] #Load just the location name.
		#end

		#@link_list = []

		#begin
		#	links = CSV.read(File.join(APP_ROOT, 'config', 'data', 'links', 'links.dat'), { :col_sep => "\t" })
		#rescue #Running outside of Sinatra?
		#	links = CSV.read('../../config/data/links/links.dat', { :col_sep => "\t" })
		#end

		#links.each do |link|
		#	@link_list << link[0] #Load just the location name.
		#end

	end

	#TODO: this method is NOT currently used by 'set-up' webhook scripts...
	#New users will be served this.
	#https://dev.twitter.com/rest/reference/post/direct_messages/welcome_messages/new
	
	def send_snow_day(recipient_id)
		message = "We should make that happen... (and I should write more code for continuing that dialog)"
		dm_content = @content.generate_message(recipient_id, message)
		send_direct_message(dm_content)
	end
	
	def send_photo(recipient_id)
		#Generate message. Static for now, but could generate/retrieve photo capture.
		message = 'Here is your (not yet) random snow photo... (testing DMs with images)'
		
		#Select photo(at random).
		photo = @photo_list.sample
		
		puts "Attempting to send #{photo}."

		dm_content = @content.generate_message_with_media(recipient_id, message, photo)
		send_direct_message(dm_content)
	end
	
	def send_map(recipient_id)
		dm_content = @content.generate_location_map(recipient_id)
		send_direct_message(dm_content)
	end

	# Sending multiple, different lists -------------------------------------

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

	def respond_to_location_choice(recipient_id, location_choice)
		dm_content = @content.acknowledge_location(recipient_id, location_choice)
		send_direct_message(dm_content)
	end

	def respond_to_map_choice(user_id, coordinates)
		dm_content = @content.acknowledge_location(recipient_id, coordinates)
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