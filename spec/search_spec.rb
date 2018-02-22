require 'spec_helper'

module OpenFec

  RSpec.configure do |config|
    config.before(:each) do

      # Search Data
      candidate_search_john = JSON.parse(File.read("spec/stubs/search/candidate_search_john.json"))
      committee_search_congress = JSON.parse(File.read("spec/stubs/search/committee_search_congress.json"))
      election_search_sentate = JSON.parse(File.read("spec/stubs/search/election_search_senate.json"))
      filings_search_2000 = JSON.parse(File.read("spec/stubs/search/filings_search_2000.json"))
      report_date_search_2000 = JSON.parse(File.read("spec/stubs/search/report_date_search_2000.json"))

      # Search Requests
      stub_request(:get, %r{https://api.open.fec.gov/v1/names/candidates/\?api_key=.*&q=John}).
          to_return(:status => 200, :body => candidate_search_john.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, %r{https://api.open.fec.gov/v1/names/committees/\?api_key=.*&q=Congress}).
          to_return(:status => 200, :body => committee_search_congress.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, %r{https://api.open.fec.gov/v1/filings/\?api_key=.*&report_year=2000}).
          to_return(:status => 200, :body => filings_search_2000.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, %r{https://api.open.fec.gov/v1/reporting-dates/\?api_key=.*&report_year=2000}).
          to_return(:status => 200, :body => report_date_search_2000.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, %r{https://api.open.fec.gov/v1/elections/search/\?api_key=.*}).
          to_return(:status => 200, :body => election_search_sentate.to_json, :headers => {'content-type' => 'application/json'})
    end
  end

  RSpec.describe Schedule do
    describe '#Search' do
      context 'Basic setup' do
        before do
          OpenFec::Client.api_key = 'STUB_API_KEY'
        end

        it "contains a valid api key" do
          expect(OpenFec::Client.has_api_key? == true)
        end

        it "allows search by candidate name" do
          search_query = 'John'
          response = OpenFec::Search.candidates(search_query)
          expect(response).to be_kind_of(OpenFec::Response)
        end

        it "allows search by committee" do
          search_query = 'Congress'
          response = OpenFec::Search.committees(search_query)
          expect(response).to be_kind_of(OpenFec::Response)
        end

        it "allows filings search by report year" do
          search_query = { 'report_year' => '2000' }
          response = OpenFec::Search.filings(search_query)
          expect(response).to be_kind_of(OpenFec::Response)
        end

        it "allows reporting dates search by report year" do
          search_query = { 'report_year' => '2000' }
          response = OpenFec::Search.reporting_dates(search_query)
          expect(response).to be_kind_of(OpenFec::Response)
        end

        it "allows elections search by office" do
          search_query = { 'office' => 'senate' }
          response = OpenFec::Search.elections(search_query)
          expect(response).to be_kind_of(OpenFec::Response)
        end
      end
    end
  end
end
