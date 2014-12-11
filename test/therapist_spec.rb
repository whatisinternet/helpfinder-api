require File.expand_path '../test_helper.rb', __FILE__
require 'json'
require 'sinatra/activerecord'
require './models/therapist'
 
include Rack::Test::Methods


describe "Therapist" do

	it "should not be empty when returing everyone" do
		Therapist.new.return_all.wont_be_empty
	end

	it "should be empty when the postal code is empty" do
		Therapist.new.find_therapists(nil,0,'km').must_be_empty
	end

	it "should return an empty array if the postal_code is nil" do
		Therapist.new.find_therapists(nil,0,'km').must_be_instance_of Array
	end

	it "should return a therapist when searching by name" do
		therapist = Therapist.new.find_by_name('Test_Therapist')
		therapist.wont_be_nil
		therapist.must_be_instance_of Therapist::ActiveRecord_Relation
	end

	it "should return local therapists" do
		check_therapists = Therapist.new.find_therapists('90210',1000,'km').refine.to_json
		therapists = [{id: 1, name: "Test Therapist", location: "123 Fake St. NY NY 90210", postal_code: "90210", phone_number: "555-555-5555", fax_number: "555-555-5555", email: "test@therapist.com", website: "api.helpfinder.com", latitude: 34.1030032, longitude: -118.4104684, distance: 1.30843375858857e-12, bearing:"270.00000002055"}]
		check_therapists.must_equal therapists.to_json
	end

	it "should create a new therapist" do
		temp = Therapist.new(name: 'Test',
			location: '123 Fake St. NY NY 90210',
			postal_code: '90210',
			phone_number: '555-555-5555',
			fax_number: '555-555-5555',
			email: 'test@therapist.com',
			website: 'api.helpfinder.com',
			latitude: '34.103003200000000000',
			longitude: '-118.410468400000010000')
		temp.must_be_instance_of Therapist
	end

	it "should create and save a new therapist" do
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
		temp2 = Therapist.find_by_name('Test')
		temp2.must_be_instance_of Therapist
		temp.destroy
		temp2.destroy
	end

	it "should delete an entry from therapist" do
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
		temp.destroy
		temp2 = Therapist.find_by_name('Test')
		temp2.must_be_nil
		
	end

end