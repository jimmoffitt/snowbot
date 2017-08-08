#Attempting to abstract away all the 'resource' metadata and management into this class.
#This class knows where things are stored (on Heroku at least)
#Could have 'dev helper' features for working on different platforms (heroku, local linux, ?).
#Sets up all object variables needed by Bot. One Stop Shop.

#Key feature design details: 
#  Supports a single list of locations 
#  Supports the look-up for a single list of links
#  Supports a single directory of JPEGs.

class GetResources

	attr_accessor :photos_home,
	              :photos_list,     #CSV with file name and caption. That's it.
	              :locations_home,
	              :locations_list, #This class knows the configurable location list.
	              :links_home,
	              :links_list,
	              :playlists_home,
	              :playlists_list
	
	def initialize()

		puts "Creating GetResources object. "

		#Load resources, populating attributes.
		@photos_home = '/app/snowbot/config/data/photos' #On Heroku at least.
		if not File.directory?(@photos_home)
			@photos_home = '../../config/data/photos'
		end
		@photos_list = []
		@photos_list = get_photos

		@links_home = '/app/snowbot/config/data/links' #On Heroku at least.
		if not File.directory?(@links_home)
			@links_home = '../../config/data/links'
		end
		@links_list = []
		@links_list = get_links

		@locations_home = '/app/snowbot/config/data/locations' #On Heroku at least.
		if not File.directory?(@locations_home)
			@locations_home = '../../config/data/locations'
		end
		@locations_list = []
		@locations_list = get_locations
		
		@playlists_home = '/app/snowbot/config/data/playlists' #On Heroku at least.
		if not File.directory?(@playlists_home)
			@playlists_home = '../../config/data/playlists'
		end
		@playlists_list = []
		@playlists_list = get_playlists

	  
		@playlists = []
		
	end

	#photo_list = [] #Load array of photo metadata.
	def get_photos
		photo_list = CSV.read("#{@photos_home}/photos.csv", {:col_sep => ";"})
		puts "Have a list of #{photo_list.count} photos..."
		photo_list
	end

	#list = [] #Load array of curated links.
	def get_links
		list = CSV.read("#{@links_home}/links.csv", {:col_sep => ";"})
		puts "Have a list of #{list.count} links..."
		list
	end

	#list = [] #Load array of curated locations.
	def get_locations
		list = CSV.read("#{@locations_home}/placesOfInterest.csv")
		puts "Have a list of #{list.count} locations..."
		list
	end

	#list = [] #Load array of curated locations.
	def get_playlists
		list = CSV.read("#{@playlists_home}/playlists.csv")
		puts "Have a list of #{list.count} playlists..."
		list
	end

	

end