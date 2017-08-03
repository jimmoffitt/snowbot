#Attempting to abstract away all the 'resource' metadata and management into this class.
#This class knows where things are stored (on Heroku at least)
#Could have 'dev helper' features for working on different platforms (heroku, local linux, ?).
#Sets up all object variables needed by Bot. One Stop Shop.

#Key feature design details: 
#  Supports a single list of locations 
#  Supports the look-up for a single list of links
#  Supports a single directory of JPEGs.

class GetResources

	attr_accessor :photo_home,
	              :photo_list,     #CSV with file name and caption. That's it.
	              :location_list, #This class knows the configurable location list.
	              :link_list,
	              :playlists
	
	def initialize()

		puts "Creating GetResources object."

		#Load resources, populating attributes.
		@photo_home = '/app/snowbot/config/data/photos' #On Heroku at least.


		if not File.directory?(@photo_home)
			@photo_home = '../../config/data/photos'
		end

		@photo_list = []
		@photo_list = get_photos

		@location_list = []
		@link_list = []
		@playlists = []
		
	end
	
	def get_photos
		photo_list = []
		#Load photo files into array.
		photo_list = CSV.read("#{@photo_home}/photos.csv", {:col_sep => ";"})
		puts "Have a list of #{photo_list.count} photos..."
		photo_list
	end
	
	def get_links

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
	
	def get_location_list

		#@location_list = []

		#begin
		#	locations = CSV.read(File.join(APP_ROOT, 'config', 'data', 'locations', 'placesOfInterest.csv'))
		#rescue #Running outside of Sinatra?
		#	locations = CSV.read('../../config/data/locations/placesOfInterest.csv')
		#end

		#locations.each do |location|
		#	@location_list << location[0] #Load just the location name.
		#end


	end
	
	
end