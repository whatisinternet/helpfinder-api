require "bundler/setup"
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/therapist'
require './models/api_user'
require 'geocoder'
require "geocoder/railtie"
Geocoder::Railtie.insert

require 'json'

enable :sessions
register Sinatra::ActiveRecordExtension

options '/*' do
  response["Access-Control-Allow-Headers"] = "origin, x-requested-with, content-type"
end

get '/api/1/find_help/:postal_code/:distance/:units' do
	return 'fail' if params[:postal_code].nil?
	get_therapist_postal(params[:postal_code].to_s, 
						 params[:distance].to_s, 
						 params[:units].to_s)

end

post '/api/1/therapist/create' do
	request_payload = parse_json(request)
	create_therapist(request_payload[1])
end

post '/api/1/therapist/delete' do
	request_payload = parse_json(request)
	delete_therapist(request_payload[1]['name'])
end

not_found do
  status 404
  'I can\'t let you do that dave'.to_json
end

helpers do
	def valid_key?(key)
		return false if key.nil?
		ApiUser.new.validate_key(key.to_s)
	end

	def parse_json(params)
		params.body.rewind
    	request_payload = JSON.parse params.body.read
		halt 404 if request_payload[0]['key'].to_s.nil?
		error 404 unless valid_key?(request_payload[0]['key'].to_s)
		request_payload
	end

	def get_therapist_postal(postal_code, distance, units)
		content_type :json
		Therapist.new.find_therapists(
			postal_code.to_s, 
			distance.to_s, 
			units.to_s).refine.to_json
	end

	def create_therapist(therapist_data)
		therapist = Therapist.new(therapist_data)
		if therapist.save
			'successfully created!'.to_json
		else
			'failed to create!'.to_json
		end
	end

	def delete_therapist(therapist_name)
		therapist = Therapist.find_by_name(therapist_name)
		if therapist.destroy
			'successfully deleted!'.to_json
		else
			'failed to deleted!'.to_json
		end
	end
end