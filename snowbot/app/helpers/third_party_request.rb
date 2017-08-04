require 'json'
require 'open-uri'

class ThirdPartyRequest

	HEADERS = {"content-type" => "application/json"} #Suggested set? Any?

	attr_accessor :keys,
	              :base_url, #Default: 'https://api.twitter.com/'
	              :uri_path #No default.

	def initialize(config_file = nil)
		
		@base_url = 'https://GetSnow.com/'
		@uri_path = ''
		
		#Get Twitter App keys and tokens. Pull from the 
		#'Config Variables' via the ENV{} hash.
		@keys = {}

		@keys['snow_consumer_key'] = ENV['SNOW_CONSUMER_KEY']
		@keys['weather_consumer_key'] = ENV['WEATHERUNDERGROUND_KEY']
		@keys['spotify_consumer_key'] = ENV['SPOTIFY_CONSUMER_KEY']

	end
	
	def get_api_access

	end

	def make_post_request(uri_path, request)
	end

	def make_get_request(uri_path)
	end

	def make_delete_request(uri_path)
	end

	def make_put_request(uri_path)
	end
	
	
	def get_current_conditions(lat,long)


		#http://api.wunderground.com/api/APIKEY/forecast/astronomy/conditions/q/42.077201843262,-8.4819002151489.json

		open("http://api.wunderground.com/api/#{@keys['weather_consumer_key']}/geolookup/conditions/q/#{lat},#{long}.json") do |f|
			json_string = f.read
			parsed_json = JSON.parse(json_string)
			
			#Generate place name
			city = parsed_json['location']['city']
			state = parsed_json['location']['state']
			country = parsed_json['location']['country_name']
			place_name = "#{city}, #{state}, #{country}" 

			#Generate weather summary
			weather = parsed_json['current_observation']['weather']
			temp = parsed_json['current_observation']['temperature_string']
			feels_like = parsed_json['current_observation']['feelslike_string']
			wind = parsed_json['current_observation']['wind_string']
			rain_today = parsed_json['current_observation']['precip_today_string']
			forecast_url = parsed_json['current_observation']['forecast_url']

			weather_summary = "#{weather}\n" +
			                  "Current temp: #{temp}\n" + 
				                "Feels like: #{feels_like}  \n" + 
			                  "Wind speed: #{wind}  \n" +
			                  "Rain today: #{rain_today}  \n" + 
			                  "For forecast, see: #{forecast_url}\n"

			return "Current weather conditions in #{place_name}: \n #{weather_summary}"
		end
		
	end
	

end


if __FILE__ == $0 #This script code is executed when running this file.

	thirdPartyAPI = ThirdPartyRequest.new
	
	response = thirdPartyAPI.get_current_conditions(40.0150,-105.2705)
	puts response
	response = thirdPartyAPI.get_current_conditions(42.3357,-95.3475)
	puts response


	#Get current weather conditions for lat/long from WeatherUnderground API?
	
	
	
	
end