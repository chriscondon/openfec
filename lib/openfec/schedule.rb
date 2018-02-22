module OpenFec
  class Schedule < Client

  	### Methods: 'merge_options', 'make_request' are found in parent Client class


			# SCHEDULE A

	    def self.a_all
	    	return schedule_request('a_all', 'sched_a_req_params')
	    end

	    def self.a_by_contributor_type(options = {})
	    	return select_request_uri('a_by_contributor_type', 'a_by_contributor_type_committee', 'sched_a_req_params', options)
	    end

	    def self.a_by_contributor_type_and_candidate(options = {})
	    	return schedule_request('a_by_contributor_type_and_candidate', 'sched_a_req_params', options)
	    end

	    def self.a_by_contributor(options = {})
	    	return select_request_uri('a_by_contributor', 'a_by_contributor_committee', 'sched_a_req_params', options)
	    end

	    def self.a_by_employer(options = {})
	    	return select_request_uri('a_by_employer', 'a_by_employer_committee', 'sched_a_req_params', options)
	    end

	    def self.a_by_occupation(options = {})
	    	return select_request_uri('a_by_occupation', 'a_by_occupation_committee', 'sched_a_req_params', options)
	    end

	    def self.a_by_size(options = {})
	    	return select_request_uri('a_by_size', 'a_by_size_committee', 'sched_a_req_params', options)
	    end

	    def self.a_by_size_and_candidate(options = {})
	    	return schedule_request('a_by_size_and_candidate', 'sched_a_req_params', options)
	    end

	    def self.a_by_state(options = {})
	    	return select_request_uri('a_by_state', 'a_by_state_committee', 'sched_a_req_params', options)
	    end

	    def self.a_by_state_and_candidate(options = {})
	    	return schedule_request('a_by_state_and_candidate', 'sched_a_req_params', options)
	    end

	    def self.a_by_zip(options = {})
    		return schedule_request('a_by_zip', 'sched_a_req_params', options)
	    end

	    # SCHEDULE B

	    def self.b_all
	    	return schedule_request('b_all', 'sched_b_req_params')
	    end

	    def self.b_by_purpose(options = {})
	    	return select_request_uri('b_by_purpose', 'b_by_purpose_committee', 'sched_b_req_params', options)
	    end

	    def self.b_by_recipient(options = {})
	    	return select_request_uri('b_by_recipient_id', 'b_by_recipient_committee', 'sched_b_req_params', options)
	    end

	    def self.b_by_recipient_id(options = {})
	    	return select_request_uri('b_by_recipient_id', 'b_by_recipient_id_committee', 'sched_b_req_params', options)
	    end

	    def self.b_by_committee_and_candidate(committee_id, options = {})
	    	return request_by_committee_id(committee_id, 'b_by_committee_and_candidate', 'sched_b_req_params', options) if is_valid(committee_id)
	    	raise "Missing committee_id parameter"
	    end

	    # SCHEDULE E

	    def self.e_all
	    	return schedule_request('e_all', 'sched_e_req_params')
	    end

	    def self.e_by_candidate(options = {})
	    	return schedule_request('e_by_candidate', 'sched_e_req_params', options)
	    end

	    #########
	    protected

	    def self.select_request_uri(endpoint_key, endpoint_committee_key, param_type, options)
	    	if committee_id = options.delete('committee_id')
	    		return request_by_committee_id(committee_id, endpoint_committee_key, param_type, options)
	    	else
	    		return schedule_request(endpoint_key, param_type, options)
	    	end
	    end

	    def self.schedule_request(schedule_endpoint, param_type, options = {})
	    	query = merge_options({'api_key' => @@api_key, 'per_page' => 100 }, options, param_type)
	    	return get_schedule_response( self.get(@@schedule_endpoints[schedule_endpoint], query: query) )
	    end

	   	def self.request_by_committee_id(committee_id, type, param_type, options = {})
    		query = { 'api_key' => @@api_key }
    		query = merge_options(query, options, param_type) unless options.empty?
    		uri = @@schedule_endpoints[type].sub('{committee_id}', committee_id)
    	 return get_schedule_response( self.get( uri, query: query ) )
	    end

	    def self.get_schedule_response(response)
	    	return Schedule_Response.new(response)
	    end

  end #class
end #module

