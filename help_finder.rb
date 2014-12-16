require "bundler/setup"
require 'sinatra'
require "sinatra/base"
require 'sinatra/activerecord'
require './config/environments'
require "./helpers/api_helpers.rb"
register Sinatra::ActiveRecordExtension

class HelpFinder < Sinatra::Base
	helpers ApiHelpers

	options '/*' do
	    headers['Access-Control-Allow-Origin'] = "*"
	    headers['Access-Control-Allow-Methods'] = "GET, POST, PUT, DELETE, OPTIONS"
	    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin"
	end

	before do
    	headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
        headers['Access-Control-Allow-Origin'] = '*'
    	headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
	end

	get '/api/1/find_help/:postal_code/:distance/:units' do
		return 'fail' if params[:postal_code].nil?
		get_therapist_postal(params[:postal_code].to_s, 
							 params[:distance].to_s, 
							 params[:units].to_s)

	end

	get '/api/1/find_help_latlong/:latitude/:longitude/:distance/:units' do
		return 'fail' if params[:latitude].nil?
		return 'fail' if params[:longitude].nil?
		get_therapist_latlong(params[:latitude].to_s, 
							 params[:longitude].to_s, 
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
	  'Computer says no.'.to_json
	end

end