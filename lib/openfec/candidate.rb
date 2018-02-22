module OpenFec
	class Candidate < Client

	    def self.all
	     candidate_request('all')
	    end

	    def self.all_where(options = {})
	  		candidate_request('all', options)
	    end

	    def self.by_name(name)
	    	raise "Failed to provide valid name for by_name search" unless is_valid(name)
	    	candidate_request('by_name', { 'name' => name.to_s })
	    end

	    def self.history(candidate_id, options = {})
	    	return request_by_candidate_id(candidate_id, 'history', options) if id_valid?(candidate_id)
	    end

	    def self.committees(candidate_id, options = {})
	    	return request_by_candidate_id(candidate_id, 'committees', options) if id_valid?(candidate_id)
	    end

	    def self.committee_history(candidate_id, options = {})
	    	return request_by_candidate_id(candidate_id, 'committee_history', options) if id_valid?(candidate_id)
	    end

	    def self.communication_costs(candidate_id, options = {})
	    	if id_valid?(candidate_id)
	    		query = { 'candidate_id' => candidate_id }
		    	query = merge_options(query, options) if hash_valid?(options)
		    	return request_by_candidate_id(candidate_id, 'communication_costs', query)
		    end
	    end

	    def self.electioneering_costs(candidate_id, options = {})
	    	if id_valid?(candidate_id)
	    		query = { 'candidate_id' => candidate_id }
	    		query = merge_options(query, options, 'candidate_req_params') if hash_valid?(options)
	    		return request_by_candidate_id(candidate_id, 'electioneering_costs', query)
	    	end
	    end

	    def self.history_by_cycle(candidate_id, cycle)
	    	raise "Parameter(s) missing for history_by_cycle" unless is_valid(candidate_id) && !cycle.nil?
	    	return get_candidate_response( self.get("/candidate/#{candidate_id}/history/#{cycle}/", query: {'api_key' => @@api_key } ))
	    end

	    def self.committee_history_by_cycle(candidate_id, cycle)
	    	raise "Parameter(s) missing for history_by_cycle" unless is_valid(candidate_id) && !cycle.nil?
	    	return get_candidate_response( self.get("/candidate/#{candidate_id}/committees/history/#{cycle}/", query: {'api_key' => @@api_key } ))
	    end


	    #########
	    protected

	   	def self.id_valid?(s)
   		  return true if is_valid(s)
   		  raise "Error: Failed to provide valid candidate_id"
	   	end

	    def self.candidate_request(type, options = {})
	    	query = {'api_key' => @@api_key }
	    	query = merge_options(query, options, 'candidate_req_params')
				response = self.get(@@candidate_endpoints[type], query: query)
	    	return get_candidate_response(response)
	    end

	   	def self.request_by_candidate_id(candidate_id, type, options = {})
	   		query = { 'api_key' => @@api_key }
	   		query = merge_options( { 'api_key' => @@api_key }, options, 'candidate_req_params') if hash_valid?(options)
    		uri = @@candidate_endpoints[type].sub('{candidate_id}', candidate_id)
				response = self.get(uri, query:query)
    		return get_candidate_response(response)
	    end

	    def self.get_candidate_response(response)
	    	return Candidate_Response.new(response)
	    end

	end #class Candidate
end #module Sunlight
