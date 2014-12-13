require "bundler/setup"
require 'sinatra'
require "sinatra/base"
require 'sinatra/activerecord'
require './config/environments'
require_relative "./helpers.rb"
register Sinatra::ActiveRecordExtension

class HelpFinder < Sinatra::Base
	include ApiHelpers

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

end