require File.expand_path '../test_helper.rb', __FILE__
require 'json'
require 'sinatra/activerecord'
require './models/therapist'
require './models/apiacceptedprogram'
 
include Rack::Test::Methods


describe "ApiAcceptedProgram" do

	it "should validate key and expiry as false" do
		key = 'asdnfjsadf'
		acceptance = ApiAcceptedProgram.new.validate_key(key)
		acceptance.must_equal false
	end

	it "should validate key and expiry as true" do
		key = ENV['helpAPIKey']
		acceptance = ApiAcceptedProgram.new.validate_key(key)
		acceptance.must_equal true
	end

	it "should validate_key" do
		key = ENV['helpAPIKey']
		acceptance = ApiAcceptedProgram.new.validate_key(key)
		acceptance.must_equal true
	end

	it "should validate the key isn't expired" do
		mock = ApiAcceptedProgram.new(app_name: 'test_app', key: 'test_key', expires: "#{Date.today + 1}")
		acceptance = ApiAcceptedProgram.new.validate_expire_date(mock)
		acceptance.must_equal true
	end

	it "should validate the key is expired" do
		mock = ApiAcceptedProgram.new(app_name: 'test_app', key: 'test_key', expires: "#{Date.today - 1}")
		acceptance = ApiAcceptedProgram.new.validate_expire_date(mock)
		acceptance.must_equal false
	end

	it "should return a hash string" do
		acceptance = ApiAcceptedProgram.new.hash_key('test_non_hashed_data')
		acceptance.must_be_instance_of String
	end

	it "should return a user" do
		key = ENV['helpAPIKey']
		acceptance = ApiAcceptedProgram.new.get_user(key)
		acceptance.must_be_instance_of ApiAcceptedProgram
	end

end