require 'httparty'

module OpenFec
  class Client
    attr_reader :api_key
    include HTTParty
    base_uri 'https://api.open.fec.gov/v1'
    @@api_key = '' # Initialize API Key to blank string
    @@api_key = ENV["OPEN_FEC_API_KEY"]

    ##################
    # Client Methods #

    def self.is_valid(string)
      !(string.nil? || string.empty?)
    end

    def self.api_key
     @@api_key
    end

    def self.hash_valid?(h = {})
      !(h.nil? || h.empty?)
    end

    def self.api_key=(key)
     @@api_key = key
    end

    def self.has_api_key?
      !(self.api_key.nil? || self.api_key.empty?)
    end

    def self.make_request(response)
      return Response.new(response)
    end

    def default_query
      #Creates a 'query' hash, setting by default 'api_key' and 'per_page => 100'
      return { 'api_key' => @@api_key } # 'per_page' => '100' }
    end

    def self.merge_options(q = {}, o = {}, param_type)
      req_params = o.select{|k, v| @@valid_request_params[param_type].include?(k.to_s)}
      req_params.each do |k, v|
        q.merge!({k.to_s => v})
      end
      return q
    end



      ##############################################
      # Hashes contain endpoints for each subclass #

       @@schedule_endpoints = { "a_all" => "/schedules/schedule_a/",
                                "a_by_contributor" => "/schedules/schedule_a/by_contributor/",
                                "a_by_contributor_type" => "/scFhedules/schedule_a/by_contributor_type/",
                                "a_by_contributor_type_and_candidate" => "/schedules/schedule_a/by_contributor_type/by_candidate/",
                                "a_by_employer" => "/schedules/schedule_a/by_employer/",
                                "a_by_occupation" => "/schedules/schedule_a/by_occupation/",
                                "a_by_size" => "/schedules/schedule_a/by_size/",
                                "a_by_size_and_candidate" => "/schedules/schedule_a/by_size/by_candidate/",
                                "a_by_state" => "/schedules/schedule_a/by_state/",
                                "a_by_state_and_candidate" => "/schedules/schedule_a/by_state/by_candidate/",
                                "a_by_zip" => "/schedules/schedule_a/by_zip/",
                                "a_by_contributor_committee" => "/committee/{committee_id}/schedules/schedule_a/by_contributor/",
                                "a_by_contributor_type_committee" => "/committee/{committee_id}/schedules/schedule_a/by_contributor_type/",
                                "a_by_employer_committee" => "/committee/{committee_id}/schedules/schedule_a/by_employer/",
                                "a_by_occupation_committee" => "/committee/{committee_id}/schedules/schedule_a/by_occupation/",
                                "a_by_size_committee" => "/committee/{committee_id}/schedules/schedule_a/by_size/",
                                "a_by_state_committee" => "/committee/{committee_id}/schedules/schedule_a/by_state/",

                                "b_all" => "/schedules/schedule_b/",
                                "b_by_purpose" => "/schedules/schedule_b/by_purpose/",
                                "b_by_recipient" => "/schedules/schedule_b/by_recipient/",
                                "b_by_recipient_id" => "/schedules/schedule_b/by_recipient_id/",
                                "b_by_purpose_committee" => "/committee/{committee_id}/schedules/schedule_b/by_purpose/",
                                "b_by_recipient_committee" => "/committee/{committee_id}/schedules/schedule_b/by_recipient/",
                                "b_by_recipient_id_committee" => "/committee/{committee_id}/schedules/schedule_b/by_recipient_id/",
                                "b_by_committee_and_candidate" => "/committee/{committee_id}/schedules/schedule_e/by_candidate/",

                                "e_all" => "/schedules/schedule_e/",
                                "e_by_candidate" => "/schedules/schedule_e/by_candidate/" }


      @@candidate_endpoints = { 'all' => '/candidates/',
                                'history' => '/candidate/{candidate_id}/history/',
                                'committees' => '/candidate/{candidate_id}/committees/',
                                'committee_history' => '/candidate/{candidate_id}/committees/history/',
                                'communication_costs' => '/communication_costs/by_candidate/',
                                'electioneering_costs' => '/electioneering_costs/by_candidate/',
                                'by_name' => '/candidates/search/' }


     @@committee_endpoints =  { 'all' => '/committees/',
                                'communication_costs' => '/committee/{committee_id}/communication_costs/by_candidate/',
                                'electioneering_costs' => '/committee/{committee_id}/electioneering_costs/by_candidate/',
                                'reports' => '/committee/{committee_id}/reports/',
                                'financial_totals' => '/committee/{committee_id}/totals/',
                                'schedule_a_by_contributor' => '/committee/{committee_id}/schedules/schedule_a/by_contributor/',
                                'schedule_a_by_employer' => '/committee/{committee_id}/schedules/schedule_a/by_employer/',
                                'history' => '/committee/{committee_id}/history/' }


      @@financial_endpoints = { 'committee_reports' => '/committee/{committee_id}/reports/',
                                'committee_totals' => '/committee/{committee_id}/totals/',
                                'elections' => '/elections/',
                                'reports_by_committee_type' => '/reports/{committee_type}/' }


         @@search_endpoints = { 'candidates' => '/names/candidates/',
                                'committees' => '/names/committees/',
                                'filings' => '/filings/',
                                'reporting_dates' => '/reporting-dates/',
                                'elections' => '/elections/search/' }


     ######################################################################
     # Hash contains arrays of valid request parameters for each subclass #

     @@valid_request_params = {


      'sched_a_req_params' => [ "max_image_number", "min_amount", "image_number", "max_date", "min_image_number", 
                                "max_amount", "min_date", "contributor_name", "is_individual", "contributor_type", 
                                "contributor_city", "committee_id", "last_contributor_aggregate_ytd", "contributor_id", 
                                "last_contribution_receipt_date", "contributor_occupation", "contributor_state", 
                                "contributor_employer", "last_contribution_receipt_amount", "last_index", "per_page", 
                                "sort", "sort_hide_null", "sort_nulls_large", "candidate_id", "cycle" ],
                             
      'sched_b_req_params' => [ "max_image_number", "min_amount", "image_number", "max_date", "min_image_number", 
                                "max_amount", "min_date", "last_disbursement_amount", "last_disbursement_date",
                                "recipient_committee_id", "recipient_name", "recipient_state", "committee_id", 
                                "disbursement_description", "recipient_city", "last_index", "per_page", "sort", 
                                "sort_hide_null", "sort_nulls_large", "candidate_id", "cycle" ],

      'sched_e_req_params' => [ "max_image_number", "min_amount", "image_number", "max_date", "min_image_number",
                                "max_amount", "min_date", "payee_name", "last_expenditure_date", "candidate_id",
                                "last_expenditure_amount", "committee_id", "last_office_total_ytd", "last_index",
                                "per_page", "sort", "sort_hide_null", "sort_nulls_large" ],

        'a_by_contributor' => [ "page","per_page","year","contributor_id","cycle","sort","sort_hide_null","sort_nulls_large" ],

    'committee_req_params' => [ "page", "per_page", "year", "designation", "committee_type", "organization_type",
                                "cycle", "party", "min_first_file_date", "candidate_id", "state", "committee_id",
                                "name", "q", "max_first_file_date", "sort", "sort_hide_null", "sort_nulls_large" ],

'candidates_search_params' => [ "q" ],

'committees_search_params' => [ "q" ],

   'filings_search_params' => [ "page","per_page","form_type","min_receipt_date","report_type","max_receipt_date","document_type",
                                "amendment_indicator","primary_general_indicator","beginning_image_number","report_year","committee_id",
                                "candidate_id","sort","sort_hide_null","sort_nulls_large" ],

  'reporting_dates_params' => [ "page","per_page","create_date","report_type","due_date","upcoming","report_year","update_date","sort",
                                "sort_hide_null","sort_nulls_large" ],

 'elections_search_params' => [ "page","per_page","district","state","zip","cycle","sort","sort_hide_null","sort_nulls_large" ],

'committee_reports_params' => [ "page","per_page","year","beginning_image_number","report_type","cycle",
                                "sort","sort_hide_null","sort_nulls_large" ],

 'committee_totals_params' => [ "page","per_page","cycle","sort","sort_hide_null","sort_nulls_large" ],

        'elections_params' => [ "page","per_page","district","state","cycle","office","sort","sort_hide_null","sort_nulls_large" ],

    'rep_cmtee_typ_params' => [ "page","per_page","year","beginning_image_number","report_type",
                                "cycle","sort","sort_hide_null","sort_nulls_large" ],

    'candidate_req_params' => [ "sort", "sort_hide_null", "year", "office", "candidate_status", "party", "state", "cycle",
                                "district", "incumbent_challenge", "name", "candidate_id", "page", "per_page" ] }


  end #class Client
end #module OpenFec
