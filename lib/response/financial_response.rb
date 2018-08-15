module OpenFec
  class FinancialResponse < OpenFecResponse
		attr_reader :pagination, :results

  	def initialize(response)
      @pagination = response["pagination"]
      @results = response["results"]
      super
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
      results.count
    end
  end #class financial_response
end #module OpenFec
