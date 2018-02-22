require 'spec_helper'

module OpenFec
  RSpec.configure do |config|
    config.before(:each) do
      candidates_all = JSON.parse(File.read("spec/stubs/client/candidates_all.json"))

      # Client Requests
      stub_request(:get, "https://api.open.fec.gov/v1/").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => candidates_all.to_json, :headers => {})
    end
  end


  RSpec.describe Client do
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
    end
  end
end
