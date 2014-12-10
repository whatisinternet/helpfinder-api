require File.expand_path '../test_helper.rb', __FILE__
require 'json'
require_relative '../help_finder.rb'
require './models/therapist'
 
include Rack::Test::Methods
 
def app
  Sinatra::Application
end

describe "Help Finder" do

	it "should return fail if nothing given" do
		get 'v1/find_help/'
		'I can\'t let you do that dave'.to_json.must_equal last_response.body
	end

	it "should return a json package for local therapists" do
		get 'v1/find_help/90210&20&km'
		therapists = [{id: 1, name: "Test Therapist", location: "123 Fake St. NY NY 90210", postal_code: "90210", phone_number: "555-555-5555", fax_number: "555-555-5555", email: "test@therapist.com", website: "api.helpfinder.com", latitude: 34.1030032, longitude: -118.4104684, distance: 1.30843375858857e-12, bearing:"270.00000002055"}]
		last_response.body.must_equal therapists.to_json

	end

	it "should return all of the therapists" do
		get 'v1/everyone'
		everyone = Therapist.all.select(
			:name, 
			:location,
			:phone_number,
			:fax_number,
			:email,
			:website).distinct.to_json
		last_response.body.must_equal everyone
	end

	it "should return json" do
		get 'v1/find_help/test&0&km'
		last_response.headers['Content-Type'].must_equal 'application/json'
	end

	it "should create a new therapist" do
		therapists = [{id: 1, name: "Test", location: "123 Fake St. NY NY 90210", postal_code: "90210", phone_number: "555-555-5555", fax_number: "555-555-5555", email: "test@therapist.com", website: "api.helpfinder.com", latitude: 34.1030032, longitude: -118.4104684, distance: 1.30843375858857e-12, bearing:"270.00000002055"}].to_json
		post('/v1/therapist/create', therapists ,{ "CONTENT_TYPE" => "application/json" })
		last_response.body.must_equal 'successfully created!'.to_json
	end

	it "should delete a therapist" do
		therapists = [{id: 1, name: "Test", location: "123 Fake St. NY NY 90210", postal_code: "90210", phone_number: "555-555-5555", fax_number: "555-555-5555", email: "test@therapist.com", website: "api.helpfinder.com", latitude: 34.1030032, longitude: -118.4104684, distance: 1.30843375858857e-12, bearing:"270.00000002055"}].to_json
		post('/v1/therapist/delete', therapists ,{ "CONTENT_TYPE" => "application/json" })
		last_response.body.must_equal 'successfully deleted!'.to_json
	end

end