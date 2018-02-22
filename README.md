# ruby-openfec


A ruby wrapper for Open Federal Elections Commission API.

## About OpenFEC API

https://api.open.fec.gov/

OpenFEC API allows you to explore the way candidates and committees fund their campaigns.

The API is a RESTful web service supporting full-text and field-specific searches on FEC data.This API allows you to explore the vast array of campaign finance data that the FEC collects. Each endpoint focuses on a different aspect of disclosure. Information is tied to the underlying forms by file ID and image ID.

Base URI:		  https://api.open.fec.gov/v1/

HTTP Method:	  GET

Response format: .json


## Installation

Add `gem 'ruby-openfec'` to your application's *Gemfile* and run `bundle install`, or install manually with `gem install ruby-openfec`.

## Configuration

Configure a client with your [API key](https://api.data.gov/signup/) before making requests.  The API Key should be stored locally as an Environment variable in your Bash or Zsh Profile, called "OPEN_FEC_API_KEY"

````
export OPEN_FEC_API_KEY=yourapikeyfromtheurlabove
````



## Usage


Request a specific page by setting the `:page` parameter. Avoid reaching rate-limits by updating the `:per_page` request parameter, up to 100.

```` rb
options = {:page => 1, :per_page => 100}
lots_of_candidates = OpenFec::Candidate.all_with(options)
````

Make requests using endpoint-specific parameters.

```` rb
options = {:party => "DEM"}
democrats = OpenFec::Candidate.all_with(options)
````

Make requests on Committee endpoint

```` rb
every_committee = OpenFec::Committee.all
````

Request Committee history, by 'committee_id' parameter
```` rb
options = {:committee_id => "C00462390"}
comm_hist = OpenFec::Committee.history(options)
````


### Local Installation

Check out the repo with `git clone http://github.com/chriscondon/ruby-openfec`, then `cd ruby-openfec`.

After checking out the repo, run `bin/setup` to install dependencies.

### Testing

Run `bundle exec rspec spec/` to run the tests.


### Classes / Methods


#### OpenFec::Candidate

```ruby
Candidate.all
Candidate.all_sort_by(field)
Candidate.all_where(options = {})
Candidate.by_name(name)
Candidate.history(candidate_id, options = {})
Candidate.committees(candidate_id, options = {})
Candidate.committee_history(candidate_id, options = {})
Candidate.communication_costs(candidate_id, options = {})
Candidate.electioneering_costs(candidate_id, options = {})
Candidate.history_by_cycle(candidate_id, cycle)
```

#### OpenFec::Committee

```ruby
Committee.all
Committee.all_sort_by(sort_field, options = {})
Committee.all_where(options)
Committee.history(options)
Committee.history_by_cycle(committee_id, cycle)
Committee.communication_costs(committee_id)
Committee.electioneering_costs(committee_id)
Committee.reports(committee_id)
Committee.financial_totals(committee_id)
Committee.schedule_a_by_contributor(committee_id)
Committee.schedule_a_by_employer(committee_id)
```

#### OpenFec::Schedule

```ruby
Schedule.a_all
Schedule.a_by_contributor(options)
Schedule.a_by_contributor_type_and_candidate(options = {})
Schedule.a_by_employer(options)
Schedule.a_by_occupation(options)
Schedule.a_by_size(options)
Schedule.a_by_size_and_candidate(options = {})
Schedule.a_by_state
Schedule.a_by_state_and_candidate(options = {})
Schedule.a_by_state(options)
Schedule.a_by_zip({options})

Schedule.b_all
Schedule.b_by_purpose({options})
Schedule.b_by_recipient(options = {})
Schedule.b_by_recipient_id(options = {})
Schedule.b_by_committee_and_candidate(committee_id, options = {})

Schedule.e_all
Schedule.e_by_candidate({options})
```

#### OpenFec::Financial

```ruby
Financial.committee_reports(committee_id)
Financial.committee_totals(committee_id)
Financial.elections({query_options})
Financial.reports_by_committee_type(committee_type)
```

#### OpenFec::Search

```ruby
Search.candidates(name)
Search.committees(name)
Search.filings(options = {})
Search.reporting_dates(options = {})
Search.elections(options = {})
```
