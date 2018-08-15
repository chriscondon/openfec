module OpenFec
  class CandidateResponse < OpenFecResponse
		attr_reader :request, :headers, :api_version, :pagination, :results

  	def initialize(response)
      #@request = response.request
      #@headers = response.headers
      #puts response.code.to_s
      if valid?(response)
        @api_version = response["api_version"]
        @pagination = response["pagination"]
        @results = response["results"]
        super
      end
    end

    def request_query
      request.options[:query]
    end

    def limit
      headers["x-ratelimit-limit"].to_i
    end

    def remaining
      headers["x-ratelimit-remaining"].to_i
    end

    def page
      pagination["page"].to_i
    end

    def pages
      pagination["pages"].to_i
    end

    def results_count
      results.count
    end

    def first_result_name
      results.first["name"]
    end

    def last_result_name
      results.last["name"]
    end

    def summary
      "PAGE #{page}/#{pages} -- RATE #{remaining}/#{limit} -- #{first_result_name} ... #{last_result_name}"
    end

    def all_committees
      @committee_names = []
      results.each { |r| @committee_names << r["name"] }
      return @committee_names
    end

  end #class candidate_response
end #module OpenFec
