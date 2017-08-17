require 'json'
require 'open-uri'

class ThirdPartyRequest

	HEADERS = {"content-type" => "application/json"} #Suggested set? Any?

	attr_accessor :keys,
	              :base_url, #Default: 'https://api.twitter.com/'
	              :uri_path #No default.

	def initialize(config_file = nil)

		puts "Creating ThirdPartyAPI object."
		
		#@base_url = 'https://GetSnow.com/'
		#@uri_path = ''
		
		#Get Twitter App keys and tokens. Pull from the 
		#'Config Variables' via the ENV{} hash.
		@keys = {}
	
		@keys['weather_consumer_key'] = ENV['WEATHERUNDERGROUND_KEY']
		@keys['snocountry_consumer_key'] = ENV['SNOCOUNTRY_KEY']
		#@keys['spotify_consumer_key'] = ENV['SPOTIFY_CONSUMER_KEY'] #Not used yet.

	end

	#http://feeds.snocountry.net/conditions.php?apiKey=KEY_ID&resortType=Alpine&action=top20
	def get_top_snow_resorts

		open("http://feeds.snocountry.net/conditions.php?apiKey=#{@keys['snocountry_consumer_key']}&resortType=Alpine&action=top20") do |f|
			json_string = f.read
			
			puts json_string
			
			parsed_json = JSON.parse(json_string)
			
			puts parsed_json
			
			
			return "Made call..."
			
		end	
		
		
	end
	
	
  #http://feeds.snocountry.net/conditions.php?apiKey=KEY_ID&ids=303001
	def get_resort_info(resort)
		
		#Given Resort name, look up resort ID
		resort_id = 303001

		open("http://feeds.snocountry.net/conditions.php?apiKey=#{@keys['snocountry_consumer_key']}&ids=#{resort_id}") do |f|
			json_string = f.read

			puts json_string

			parsed_json = JSON.parse(json_string)

			puts parsed_json


			return "Made call..."

		end



		resort_summary = '(Not implemented yet... by this fall? Trying to find a free snow report API)'
		return "#{resort} information: \n #{resort_summary}"
	end

	def get_current_weather(lat,long)


		#http://api.wunderground.com/api/APIKEY/forecast/astronomy/conditions/q/42.077201843262,-8.4819002151489.json

		open("http://api.wunderground.com/api/#{@keys['weather_consumer_key']}/geolookup/conditions/q/#{lat},#{long}.json") do |f|
			json_string = f.read
			parsed_json = JSON.parse(json_string)
			
			if parsed_json['response'] && parsed_json['response']['error']
				return "No weather report available for that location"
			end

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

			weather_summary = "* #{weather}\n" +
			                  "* Current temp: #{temp}\n" +
				                "* Feels like: #{feels_like}  \n" +
			                  "* Wind speed: #{wind}  \n" +
			                  "* Rain today: #{rain_today}  \n" +
			                  "--> #{forecast_url}\n"

			return "Current weather conditions in #{place_name}: \n #{weather_summary}"
		end
		
	end

end

if __FILE__ == $0 #This script code is executed when running this file.

	thirdPartyAPI = ThirdPartyRequest.new

	#Testing WeatherUnderground
	#response = thirdPartyAPI.get_current_weather(5,-15)
	#puts response
	#response = thirdPartyAPI.get_current_weather(40.0150,-105.2705)
	#puts response
	#response = thirdPartyAPI.get_current_weather(42.3357,-95.3475)
	#puts response
	
	
	#response = thirdPartyAPI.get_top_snow_resorts
	
	response = thirdPartyAPI.get_resort_info('The Remarkables')
	puts response
	

end