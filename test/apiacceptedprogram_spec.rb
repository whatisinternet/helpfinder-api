require File.expand_path '../test_helper.rb', __FILE__
require 'json'
require 'sinatra/activerecord'
require './models/therapist'
require './models/apiacceptedprogram'
 
include Rack::Test::Methods


describe "ApiAcceptedProgram" do

	it "should validate key and expiry as false" do
		key = 'asdnfjsadf'
		acceptance = ApiAcceptedProgram.new.validate_key?(key)
		acceptance.must_equal false
	end

	it "should validate key and expiry as true" do
		key = ENV['helpAPIKey']
		acceptance = ApiAcceptedProgram.new.validate_key?(key)
		acceptance.must_equal true
	end

end