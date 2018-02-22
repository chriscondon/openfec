require 'spec_helper'

module OpenFec

  RSpec.configure do |config|
    config.before(:each) do

      # Candidate Data
      committees_C00563023 = JSON.parse(File.read("spec/stubs/committee/committee_history_C00462390.json"))
      committees_va = JSON.parse(File.read("spec/stubs/committee/committees_va.json"))
      committee_history_C00462390 = JSON.parse(File.read("spec/stubs/committee/committee_history_C00462390.json"))
      committee_history_2012 = JSON.parse(File.read("spec/stubs/committee/committee_history_2012.json"))

      # Candidate Requests
      stub_request(:get, "https://api.open.fec.gov/v1/committees/?api_key=").
          to_return(:status => 200, :body => committees_C00563023.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/committees/?api_key=&committee_id=C00563023").
          to_return(:status => 200, :body => committees_C00563023.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/committees/?api_key=&state=VA").
          to_return(:status => 200, :body => committees_va.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/committees/?api_key=").
          to_return(:status => 200, :body => committees_va.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/committee/C00462390/history/?api_key=").
          to_return(:status => 200, :body => committee_history_C00462390.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/committee/C00462390/history/2012/?api_key=").
          to_return(:status => 200, :body => committee_history_2012.to_json, :headers => {'content-type' => 'application/json'})
    end
  end


  RSpec.describe Committee do
    describe '#committees' do
      context 'when configured' do
        before do
          OpenFec::Client.api_key = ENV['OPEN_FEC_API_KEY']
        end


        it "contains a valid api key" do
          expect(OpenFec::Client.has_api_key? == true)
        end


        it "returns valid json responses" do
          response = OpenFec::Committee.all
          expect(response).to be_kind_of(OpenFec::Response)
        end


        it "returns responses filtered on Committee_ID" do
          options = { 'committee_id' => "C00563023" }
          response = OpenFec::Committee.all_where(options)
          expect(response.results.map{|c| c["treasurer_name"]}.uniq).to eql(["EDEAN BUNDICK"])
        end


        it "filters committee by state" do
          options = {:state => "VA"}
          response = OpenFec::Committee.all_where(options)
          expect(response.results.map{|c| c["state"]}.uniq).to eql(["VA"])
        end


        it "prevents unrecognized params from being requested" do
          unrecognized_params = {:favorite_show => "Seinfeld"}
          response = OpenFec::Committee.all_where(unrecognized_params)
          recognized_params = response.request_query
          expect(!recognized_params.keys.include?("favorite_show"))
        end


        it "returns Committee history" do
          options = "C00462390"
          response = OpenFec::Committee.history(options)
          expect(response.results.map{|c| c["treasurer_name"]}.uniq).to eql(["EDEAN BUNDICK"])
        end


        it "returns Committee history by cycle" do
          id = "C00462390"
          cyc = "2012"
          response = OpenFec::Committee.history_by_cycle(id, cyc)
          expect(response.results.map{|c| c["treasurer_name"]}.uniq).to eql(["EDEAN BUNDICK"])
        end


        it "raises an error if one of the parameters is missing for history_by_cycle method" do
          id = "C00462390"
          cycle = nil
          expect { response = OpenFec::Committee.history_by_cycle(id, cycle) }.to raise_error(RuntimeError)
        end

      end #context
    end #describe committee
  end #Rspec.describe
end #OpenFec
