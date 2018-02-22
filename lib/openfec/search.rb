module OpenFec
	class Search < Client



		def self.candidates(name)
			raise "Missing search parameter for candidates search" unless is_valid(name)
			options = { 'q' => name.to_s }
			search_request('candidates', 'candidates_search_params', options )
		end

		def self.committees(name)
			raise "Missing search parameter for committees search" unless is_valid(name)
			options = { 'q' => name.to_s }
			search_request('committees', 'committees_search_params', options )
		end

		def self.filings(options = {})
			raise "Missing search parameters for filings search" unless hash_valid?(options)
			search_request('filings', 'filings_search_params', options )
		end

		def self.reporting_dates(options = {})
			raise "Missing search parameters for reporting_dates search" unless hash_valid?(options)
			search_request('reporting_dates', 'reporting_dates_params', options )
		end

	  def self.elections(options = {})
	  	raise "Missing search parameters for elections search" unless hash_valid?(options)
			search_request('elections', 'elections_search_params', options )
		end


    #********
		protected

    def self.search_request(search_endpoint, param_type, options = {})
    	query = {'api_key' => @@api_key }
    	query = merge_options(query, options, param_type)
    	return make_request( self.get(@@search_endpoints[search_endpoint], query: query) )
    end

    def self.get_search_response(response)
    	return Search_Response.new(response)
    end

	end #class Search
end #module OpenFec
