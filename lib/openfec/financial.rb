module OpenFec
	class Financial < Client

      @@financial_endpoints = { 'committee_reports' => '/committee/{committee_id}/reports/',
                                'committee_totals' => '/committee/{committee_id}/totals/',
                                'elections' => '/elections/',
                                'reports_by_committee_type' => '/reports/{committee_type}/' }


		def self.committee_reports(committee_id, options = {})
			if id_valid?(committee_id)
				return financial_request_by_committee_id(committee_id, 'committee_reports', 'committee_reports_params', options)
			end
		end

		def self.committee_totals(committee_id, options  = {})
			if id_valid?(committee_id)
				return financial_request_by_committee_id(committee_id, 'committee_totals', 'committee_totals_params', options)
			end
		end

		def self.elections(options = {})
			raise "Error: missing params for Financial.elections() method" unless hash_valid?(options)
			return financial_request('elections', 'elections_params', options)
		end

		def self.reports_by_committee_type(committee_type, options = {})
			if type_valid?(committee_type)
				return financial_request_by_committee_type(committee_type, 'reports_by_committee_type', 'rep_cmtee_typ_params', options)
			end
		end

		protected

   	def self.id_valid?(s)
   	  return true if is_valid(s)
   	  raise "Error: Failed to provide a committee_id"
   	end

   	def self.type_valid?(s)
   	  return true if is_valid(s)
   	  raise "Error: Failed to provide a committee_type"
   	end

    def self.financial_request(financial_endpoint, param_type, options = {})
    	query = {'api_key' => @@api_key }
    	query = merge_options(query, options, param_type)
      return get_financial_response( self.get(@@financial_endpoints[financial_endpoint], query: query))
    end

   	def self.financial_request_by_committee_id(committee_id, type, param_type, options = {})
  		query = { 'api_key' => @@api_key }
  		query = merge_options(query, options, param_type) unless options.empty?
  		uri = @@financial_endpoints[type].sub('{committee_id}', committee_id)
      return get_financial_response(self.get( uri, query: query ))
    end

   	def self.financial_request_by_committee_type(committee_type, type, param_type, options = {})
  		query = { 'api_key' => @@api_key }
  		query = merge_options(query, options, param_type) unless options.empty?
  		uri = @@financial_endpoints[type].sub('{committee_type}', committee_type)
      return get_financial_response(self.get( uri, query: query ))
    end

    def self.get_financial_response(response)
      return Financial_Response.new(response)
    end
	end #class Financial
end #module OpenFec
