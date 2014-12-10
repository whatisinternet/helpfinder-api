require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/therapist'
require './models/apiacceptedprogram'

require 'json'

enable :sessions

get '/v1/find_help/:postal_code&:distance&:units' do
	return 'fail' if params[:postal_code].nil?
	content_type :json
	Therapist.new.find_therapists(
		params[:postal_code].to_s, 
		params[:distance].to_s, 
		params[:units].to_s).refine.to_json
end

get '/v1/everyone' do
	halt 404 if params[:key].nil?
	error 404 unless valid_key?(params[:key])
	Therapist.new.return_all.refine.to_json
end

post '/v1/therapist/create' do
	halt 404 if params[:key].nil?
	error 404 unless valid_key?(params[:key])
	therapist = Therapist.new(params)
	if therapist.save
		'successfully created!'.to_json
	else
		'failed to create!'.to_json
	end

end

post '/v1/therapist/delete' do
	halt 404 if params[:key].nil?
	error 404 unless valid_key?(params[:key])
	therapist = Therapist.find_by_name(params[:name])
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
	def valid_key?
		return false if params[:key].nil?
		ApiAcceptedProgram.valid_key?(key.to_s)
	end
end