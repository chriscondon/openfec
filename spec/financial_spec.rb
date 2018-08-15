require 'spec_helper'

module OpenFec

  RSpec.configure do |config|
    config.before(:each) do

      # Financial Data
      reports_C00563023 = JSON.parse(File.read("spec/stubs/financial/C00563023_reports.json"))
      totals_C00563023 = JSON.parse(File.read("spec/stubs/financial/C00563023_totals.json"))
      presidential_2000_cycle = JSON.parse(File.read("spec/stubs/financial/presidential_2000_cycle.json"))
      presidential_reports = JSON.parse(File.read("spec/stubs/financial/presidential_reports.json"))

      # Financial Requests
      stub_request(:get, "https://api.open.fec.gov/v1/committee/C00563023/reports/?api_key=").
          to_return(:status => 200, :body => reports_C00563023.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/committee/C00563023/totals/?api_key=").
          to_return(:status => 200, :body => totals_C00563023.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/reports/presidential/?api_key=").
          to_return(:status => 200, :body => presidential_2000_cycle.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/elections/?api_key=&cycle=2000&office=president").
          to_return(:status => 200, :body => presidential_reports.to_json, :headers => {'content-type' => 'application/json'})
    end
  end



  RSpec.describe Schedule do
    describe '#Financial' do
      context 'Basic setup' do
        before do
          OpenFec::Client.api_key = ENV['OPEN_FEC_API_KEY']
        end

        it "contains a valid api key" do
          expect(OpenFec::Client.has_api_key? == true)
        end

        it "returns committee reports financial data by committee id" do
          committee_id = 'C00563023'
          response = OpenFec::Financial.committee_reports(committee_id)
          puts response.results
          expect(response).to be_kind_of(OpenFec::FinancialResponse)
        end

        it "returns committee totals financial data by committee id" do
          committee_id = 'C00563023'
          response = OpenFec::Financial.committee_totals(committee_id)
          puts response.results
          expect(response).to be_kind_of(OpenFec::FinancialResponse)
        end

        it "returns committee reports by committee type" do
          committee_type = 'presidential'
          response = OpenFec::Financial.reports_by_committee_type(committee_type)
          expect(response).to be_kind_of(OpenFec::FinancialResponse)
        end

        it "allows search by office and cycle" do
          search_query = { 'office' => 'president', 'cycle' => '2000'}
          response = OpenFec::Financial.elections(search_query)
          expect(response).to be_kind_of(OpenFec::FinancialResponse)
        end
      end
    end
  end
end
