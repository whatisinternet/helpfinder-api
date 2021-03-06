require File.expand_path '../test_helper.rb', __FILE__
require 'json'
require_relative '../help_finder.rb'
require './models/therapist'
 
include Rack::Test::Methods
 
def app
  HelpFinder
end

describe "Help Finder" do
	key = ENV['helpAPIKey']

	it "should return fail if nothing given" do
		get 'api/1/find_help/'
		'Computer says no.'.to_json.must_equal last_response.body
	end

	it "should return a json package for local therapists" do
		get 'api/1/find_help/90210/20/km'
		therapists = {id: 1, name: "Test Therapist", location: "123 Fake St. NY NY 90210", postal_code: "90210", phone_number: "555-555-5555", fax_number: "555-555-5555", email: "test@therapist.com", website: "api.helpfinder.com", latitude: 34.1030032, longitude: -118.4104684, distance: 0.0, bearing:"0.0"}
		last_response.body.must_include therapists.to_json
	end

	it "should return a json package for local therapists" do
		get 'api/1/find_help/Beverly%20Hills/20/km'
		last_response.body.must_include 'name'
		last_response.body.must_include 'location'
		last_response.body.must_include 'website'
		last_response.body.must_include 'phone_number'
		last_response.body.must_include 'latitude'
		last_response.body.must_include 'longitude'
	end

	it "should return a json package for local therapists (latitude longitude)" do
		get 'api/1/find_help_latlong/34.1030032/-118.4104684/1000/km'
		last_response.body.must_include 'name'
		last_response.body.must_include 'location'
		last_response.body.must_include 'website'
		last_response.body.must_include 'phone_number'
		last_response.body.must_include 'latitude'
		last_response.body.must_include 'longitude'
	end

	it "should return json" do
		get 'api/1/find_help/test/0/km'
		last_response.headers['Content-Type'].must_equal 'application/json'
	end

	it "should create a new therapist" do
		therapists = [{key: key.to_s}, {name: "Test", location: "123 Fake St. NY NY 90210", postal_code: "90210", phone_number: "555-555-5555", fax_number: "555-555-5555", email: "test@therapist.com", website: "api.helpfinder.com", latitude: 34.1030032, longitude: -118.4104684}].to_json
		post('/api/1/therapist/create', therapists ,{ "CONTENT_TYPE" => "application/json" })
		last_response.body.must_equal 'successfully created!'.to_json
	end

	it "should not create a new therapist" do
		therapists = [{key: 'fail_key'}, {name: "Test", location: "123 Fake St. NY NY 90210", postal_code: "90210", phone_number: "555-555-5555", fax_number: "555-555-5555", email: "test@therapist.com", website: "api.helpfinder.com", latitude: 34.1030032, longitude: -118.4104684}].to_json
		post('/api/1/therapist/create', therapists ,{ "CONTENT_TYPE" => "application/json" })
		last_response.body.must_equal 'Computer says no.'.to_json
	end

	it "should delete a therapist" do
		temp = Therapist.new(name: 'Test',
			location: '123 Fake St. NY NY 90210',
			postal_code: '90210',
			phone_number: '555-555-5555',
			fax_number: '555-555-5555',
			email: 'test@therapist.com',
			website: 'api.helpfinder.com',
			latitude: '34.103003200000000000',
			longitude: '-118.410468400000010000')
		temp.save
		therapists = [{key: key.to_s}, {name: "Test"}].to_json
		post('/api/1/therapist/delete', therapists ,{ "CONTENT_TYPE" => "application/json" })
		last_response.body.must_equal 'successfully deleted!'.to_json
		temp.destroy unless temp.nil?
	end


	it "should not delete a therapist" do
		therapists = [{key: 'fail_key'}, {name: "Test", location: "123 Fake St. NY NY 90210", postal_code: "90210", phone_number: "555-555-5555", fax_number: "555-555-5555", email: "test@therapist.com", website: "api.helpfinder.com", latitude: 34.1030032, longitude: -118.4104684}].to_json
		post('/api/1/therapist/create', therapists ,{ "CONTENT_TYPE" => "application/json" })
		last_response.body.must_equal 'Computer says no.'.to_json
	end

end