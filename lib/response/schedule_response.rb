module OpenFec
  class Schedule_Response < Response
		attr_reader :pagination, :results

  	def initialize(response)
      @pagination = response["pagination"]
      @results = response["results"]
      super
    end

    def request_query
      request.options[:query]
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
      @results.count
    end

    def by_size
      #return hash of candidate's schedule A contributions by size.
      @contributions = {}
      percentages = {}
      total = 0
      if !@results.nil?
        @results.each do |r|
          total += r['total']
          @contributions[ r['size'].to_s ] = r['total']
        end
      end
      @contributions.each do |k, v|
        percentages[k + '-percent'] = (@contributions[k] / total).round(4)
      end
      @contributions.merge!(percentages)
      @contributions['total'] = total.round(2).to_s
      return @contributions
    end

    def by_contributor_type
      @contributions = {}
      total = 0
      if !@results.nil?
        @results.each do |r|
          total += r["total"]
          if r["individual"]
            @contributions['individual'] = r["total"]
          else
            @contributions['committee'] = r["total"]
          end
        end
      end
      @contributions['individual-percent'] = (@contributions['individual'] / total).round(4) unless @contributions['individual'].nil?
      @contributions['committee-percent'] = (@contributions['committee'] / total).round(4) unless @contributions['committee'].nil?
      @contributions['total'] = total.to_s
      return @contributions
    end

    def by_state(home_state)
      @contributions = {}
      total = 0
      outside_contrib = 0
      if !@results.nil?
        @results.each do |r|
          total += r['total']
          if r['state'] == home_state
            @contributions['home-contribution'] = r['total']
          end
        end
      end
      @contributions['outside-contribution'] = (total - @contributions['home-contribution']).round(2) unless @contributions['home-contribution'].nil?
      @contributions['home-contribution'] = (@contributions['home-contribution']).round(2) unless @contributions['home-contribution'].nil?
      @contributions['total'] = total.round(2)
      return @contributions
    end


  end #class schedule_response
end #module OpenFec
