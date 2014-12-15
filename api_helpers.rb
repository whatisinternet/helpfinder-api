require './models/therapist'
require './models/api_user'
require 'json'

module ApiHelpers
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

		def get_therapist_latlong(latitude, longitude, distance, units)
			content_type :json
			Therapist.new.find_therapists_latlong(
				latitude.to_s, 
				longitude.to_s, 
				distance.to_s, 
				units.to_s).refine.to_json
		end

		def create_therapist(therapist_data)
			therapist = Therapist.new(therapist_data)
			if therapist.save
				'successfully created!'.to_json
			end
		end

		def delete_therapist(therapist_name)
			therapist = Therapist.find_by_name(therapist_name)
			if therapist.destroy
				'successfully deleted!'.to_json
			end
		end
	end