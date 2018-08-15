require 'spec_helper'
require 'json'


module OpenFec

  RSpec.configure do |config|
    config.before(:each) do

      # Candidate Data
      candidates_from_va = JSON.parse(File.read("spec/stubs/candidate/candidates_from_va.json"))
      dem_candidates = JSON.parse(File.read("spec/stubs/candidate/dem_candidates.json"))
      candidates_1980 = JSON.parse(File.read("spec/stubs/candidate/candidates_1980.json"))
      candidates_henry = JSON.parse(File.read("spec/stubs/candidate/candidates_from_va.json"))
      history_by_candidate_id = JSON.parse(File.read("spec/stubs/candidate/history_by_candidate_id.json"))
      by_candidate_id_and_cycle = JSON.parse(File.read("spec/stubs/candidate/history_by_candidate_id_and_year.json"))
      committees_for_candidate_id = JSON.parse(File.read("spec/stubs/candidate/committees_for_candidate_id.json"))
      history_for_candidate_id = JSON.parse(File.read("spec/stubs/candidate/history_for_candidate_id.json"))
      candidate_comm_costs = JSON.parse(File.read("spec/stubs/candidate/candidate_communication_costs.json"))
      candidate_committee_names = JSON.parse(File.read("spec/stubs/candidate/candidate_committee_names.json"))

      # Candidate Requests
      stub_request(:get, "https://api.open.fec.gov/v1/candidates/?api_key=&state=VA").
          to_return(:status => 200, :body => candidates_from_va.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/candidates/?api_key=&party=DEM").
          to_return(:status => 200, :body => dem_candidates.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/candidates/?api_key=&cycle=1980").
          to_return(:status => 200, :body => candidates_1980.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/candidate/Henry/history/?api_key=").
          to_return(:status => 200, :body => candidates_from_va.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/candidate/H0AK00014/history/?api_key=").
          to_return(:status => 200, :body => history_by_candidate_id.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/candidate/H0AK00014/history/1980/?api_key=").
          to_return(:status => 200, :body => by_candidate_id_and_cycle.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/candidate/H0AK00014/committees/?api_key=").
          to_return(:status => 200, :body => committees_for_candidate_id.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/candidate/S8MN00438/committees/history/?api_key=").
        to_return(:status => 200, :body => history_for_candidate_id.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/communication_costs/by_candidate/?api_key=&candidate_id=H0AL03036").
        to_return(:status => 200, :body => candidate_comm_costs.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/candidate/H4IL07037/committees/?api_key=").
        to_return(:status => 200, :body => candidate_committee_names.to_json, :headers => {'content-type' => 'application/json'})
      stub_request(:get, "https://api.open.fec.gov/v1/candidates/?api_key=").
        to_return(:status => 200, :body => candidates_from_va.to_json, :headers => {'content-type' => 'application/json'})
    end
  end


  RSpec.describe OpenFec::Candidate do
    describe '#Candidate' do
      context 'When configured' do
        before do
          OpenFec::Client.api_key = ENV['OPEN_FEC_API_KEY']
        end

        it "contains an api key" do
          expect(OpenFec::Client.has_api_key? == true)
        end

        it "filters candidates by state" do
          options = {:state => "VA"}
          response = OpenFec::Candidate.all_where(options)
          expect(response.results.map{|c| c["state"]}.uniq).to eql(["VA"])
        end

        it "filters candidates by party" do
          options = {:party => "DEM"}
          response = OpenFec::Candidate.all_where(options)

          expect(response.results.map{|c| c["party"]}.uniq).to eql(["DEM"])
        end

        it "filters candidates by cycle" do
          options = {:cycle => "1980"}
          response = OpenFec::Candidate.all_where(options)

          cycs = response.results.map{|c| c["cycle"]}.uniq
          expect(cycs.include?("1980"))
        end

        it "allows search of candidates by name" do
          options = "Henry"
          response = OpenFec::Candidate.history(options)
          names = response.results.map{|c| c["name"]}.uniq
          expect(names.include?("KELLEY, HENRY ARTHUR JR"))
        end

        it "allows search of candidate history by candidate_id" do
          id = "H0AK00014"
          response = OpenFec::Candidate.history(id)
          expect(response.results.map{|c| c["name"]}.uniq).to eql(["WHITTAKER, RICHARD"])
        end

        it "allows search of candidate history by candidate_id and cycle" do
          id = "H0AK00014"
          cyc = "1980"
          response = OpenFec::Candidate.history_by_cycle(id, cyc)
          expect(response.results.map{|c| c["first_file_date"]}.uniq).to eql(["1980-06-16"])
        end

        it "prevents unrecognized params from being requested" do
          unrecognized_params = {:home_planet => "Mars"}
          response = OpenFec::Candidate.all_where(unrecognized_params)
          recognized_params = response.request_query
          expect(!recognized_params.keys.include?("home_planet"))
        end

        it "will list all committees associated with a candidate_id" do
          id = "H0AK00014"
          response = OpenFec::Candidate.committees(id)
          expect(response.results.map{|c| c["city"]}.uniq).to eql(["KETCHIKAW"])
        end

        it "will return history about a given candidate's committtees" do
          id = "S8MN00438"
          response = OpenFec::Candidate.committee_history(id)
          cmttee_names = response.results.map{|c| c["name"]}.uniq
          expect(cmttee_names.include?("AL FRANKEN FOR SENATE 2014"))
        end

        it "will show communication costs for each candidate " do
          id = "H0AL03036"
          response = OpenFec::Candidate.communication_costs(id)
          treas_names = response.results.map{|c| c["treasurer_name"]}.uniq
          expect(treas_names.include?("JOHN J BANOVIC"))
        end

        it "returns a list of committe names for a given candidate " do
          id = "H4IL07037"
          response = OpenFec::Candidate.committees(id)
          @committee_names = response.all_committees
          expect(@committee_names.include?("DAVIS FOR CONGRESS/FRIENDS OF DAVIS"))
        end
      end
    end
  end
end
