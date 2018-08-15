module OpenFec
  class OpenFecResponse
    attr_reader :pagination, :results
     def initialize(response)
       if valid?(response)
         @request = response.request
         @headers = response.headers
       end
     end

     def valid?(response)
       if response.code == 403
         error = response['error']
         message = error['message']
         raise RuntimeError, message
       elsif response.code == 400
         raise RuntimeError, "OpenFEC API Service cannot process this request"
       elsif response.code == 404
         raise RuntimeError, "OpenFEC API Service cannot be found"
       else
         return true
       end
     end
  end
end
