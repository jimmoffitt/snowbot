require 'twitter' #Opens doors to rest of public Twitter APIs.
#https://github.com/sferik/twitter/blob/master/examples/Configuration.md

class TwitterAPI

	attr_accessor :keys,
	              :upload_client,
	              :base_url, # 'https://api.twitter.com/' or 'upload.twitter.com' or ?
	              :uri_path #No default.

		def initialize(config_file = nil)

      @base_url = 'upload.twitter.com'
			@uri_path = '/1.1/media/upload'
			
			if config_file.nil?
				config = '../../config/config_private.yaml'
			else
				config = config_file
			end

			#Get Twitter App keys and tokens. Read from 'config.yaml' if provided, or if running on Heroku, pull from the
			#'Config Variables' via the ENV{} hash.
			@keys = {}

			if File.file?(config)
				#puts "Pulling keys from #{config}"
				@keys = YAML::load_file(config)
				@keys = keys['dm_api']
			else
				#puts "Pulling keys from ENV[]"
				@keys['consumer_key'] = ENV['CONSUMER_KEY']
				@keys['consumer_secret'] = ENV['CONSUMER_SECRET']
				@keys['access_token'] = ENV['ACCESS_TOKEN']
				@keys['access_token_secret'] = ENV['ACCESS_TOKEN_SECRET']
			end

			@upload_client = Twitter::REST::Client.new(@keys)
	
	end
  
	def get_media_id(media)
    media_id = @upload_client.upload(File.new(media))
	end

end

