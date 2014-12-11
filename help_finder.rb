require "bundler/setup"
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/therapist'
require './models/apiacceptedprogram'
require 'geocoder'
require "geocoder/railtie"
Geocoder::Railtie.insert

require 'json'

enable :sessions
register Sinatra::ActiveRecordExtension

get '/v1/find_help/:postal_code&:distance&:units' do
	return 'fail' if params[:postal_code].nil?
	content_type :json
	Therapist.new.find_therapists(
		params[:postal_code].to_s, 
		params[:distance].to_s, 
		params[:units].to_s).refine.to_json
end

get '/v1/everyone/:key' do
	halt 404 if params[:key].nil?
	error 404 unless valid_key?(params[:key])
	Therapist.new.return_all.to_json
end

post '/v1/therapist/create' do
	request.body.rewind
    request_payload = JSON.parse request.body.read
	halt 404 if request_payload[0]['key'].to_s.nil?
	error 404 unless valid_key?(request_payload[0]['key'].to_s)
	therapist = Therapist.new(request_payload[1])
	#local = Geocoder.search(therapist.location)
	#puts local.first.coordinates
	#therapist.latitude  = local.first.latitude
	#therapist.longitude = local.first.longitude
	if therapist.save
		'successfully created!'.to_json
	else
		'failed to create!'.to_json
	end

end

post '/v1/therapist/delete' do
	request.body.rewind
    request_payload = JSON.parse request.body.read
	halt 404 if request_payload[0]['key'].nil?
	error 404 unless valid_key?(request_payload[0]['key'].to_s)
	therapist = Therapist.find_by_name(request_payload[1]['name'])
	if therapist.destroy
		'successfully deleted!'.to_json
	else
		'failed to deleted!'.to_json
	end
end

not_found do
  status 404
  'I can\'t let you do that dave'.to_json
end

helpers do
	def valid_key?(key)
		return false if key.nil?
		ApiAcceptedProgram.new.validate_key?(key.to_s)
	end
end