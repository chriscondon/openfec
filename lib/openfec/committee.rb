module OpenFec
	class Committee < Client

	    def self.all
	    	return committee_request('all')
	    end

	    def self.all_sort_by(sort_field, options = {})
	    	options = merge_options( {'sort' => sort_field}, options, 'committee_req_params')
	    	return committee_request('all', options)
	    end

	    def self.all_where(options = {})
	    	return committee_request('all', options)
	    end

	    def self.history(committee_id)
	    	return request_by_committee_id(committee_id, 'history') if id_valid?(committee_id)
	    end

	    def self.communication_costs(committee_id)
	    	return request_by_committee_id(committee_id, 'communication_costs') if id_valid?(committee_id)
	    end

	   	def self.electioneering_costs(committee_id)
	    	return request_by_committee_id(committee_id, 'electioneering_costs') if id_valid?(committee_id)
	    end

	    def self.reports(committee_id)
	    	return request_by_committee_id(committee_id, 'reports') if id_valid?(committee_id)
	    end

	    def self.financial_totals(committee_id)
	    	return request_by_committee_id(committee_id, 'financial_totals') if id_valid?(committee_id)
	    end

	    def self.schedule_a_by_contributor(committee_id)
	    	return request_by_committee_id(committee_id, 'schedule_a_by_contributor') if id_valid?(committee_id)
	    end

	    def self.schedule_a_by_employer(committee_id)
	    	return request_by_committee_id(committee_id, 'schedule_a_by_employer') if id_valid?(committee_id)
	    end

	    def self.history_by_cycle(committee_id, cycle, options = {})
	    	raise "Parameters(s) missing for history_by_cycle" unless (is_valid(committee_id) && is_valid(cycle))
				query = merge_options( {'api_key' => @@api_key }, options, 'committee_req_params')
				return get_committee_response( self.get("/committee/#{committee_id}/history/#{cycle}/", query: query) )
	    end

	    #########
	   	protected

	   	def self.id_valid?(s)
	   	  return true if is_valid(s)
	   	  raise "Error: Failed to provide a committee_id"
	   	end

	   	def self.committee_request(committee_endpoint, options = {})
	 			query = merge_options( {'api_key' => @@api_key }, options, 'committee_req_params')
	      return get_committee_response( self.get(@@committee_endpoints[committee_endpoint], query: query ) )
	   	end

	   	def self.request_by_committee_id(committee_id, type)
    		query = { 'api_key' => @@api_key }
    		uri = @@committee_endpoints[type].sub('{committee_id}', committee_id)
    		return get_committee_response(self.get( uri, query: query ) )
	    end

	    def self.get_committee_response(response)
	    	return Committee_Response.new(response)
	    end

	end #class Committee
end #module OpenFec
