require 'spec_helper'
#
module OpenFec

  RSpec.configure do |config|
    config.before(:each) do

      # Response Stub Data
      invalid_key_response = JSON.parse(File.read("spec/stubs/client/invalid_key_response.json"))
      candidates_all = JSON.parse(File.read("spec/stubs/client/candidates_all.json"))

      # Response URI Stubs
      stub_request(:get, %r{https://api.open.fec.gov/v1/.*api_key=BAD_API_KEY.*}).
          to_return(:status => 403, :body => invalid_key_response.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => candidates_all.to_json, :headers => {})
    end
  end

  RSpec.describe Response do
    describe '#Client' do
      context 'With valid API key' do
        before do
          OpenFec::Client.api_key = ENV["OPEN_FEC_API_KEY"]
          @client = OpenFec::Client.new
        end

        it "confirms client contains API Key" do
          expect(OpenFec::Client.has_api_key? == true)
        end
      end

      context 'When incorrect key provided' do
        before do
          OpenFec::Client.api_key = "BAD_API_KEY"
          @client = OpenFec::Client.new
        end

        it "raises error for Invalid API Key" do
          query = { 'api_key' => 'BAD_API_KEY' }
          response = OpenFec::Client.get('/?api_key=BAD_API_KEY', query)
          expect{OpenFec::Client.make_request(response)}.to raise_error(RuntimeError)
        end
      end
    end
  end
end
