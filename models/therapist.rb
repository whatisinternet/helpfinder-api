require 'geocoder'
require "geocoder/railtie"
Geocoder::Railtie.insert

class Therapist < ActiveRecord::Base
	extend Geocoder::Model::ActiveRecord
	geocoded_by :location
	after_validation :geocode  

	def find_therapists(postal_code, distance, units)
		return [] if postal_code.nil?
		if units.downcase.to_s == 'km'
			valid_therapists = Therapist.near(postal_code, distance.to_i, :units => :km)
		else
			valid_therapists = Therapist.near(postal_code, distance.to_i, :units => :mi)
		end
		
	end

	def return_all
		Therapist.all
	end

	def find_by_name(name)
		Therapist.where(name: name.to_s)
	end

	def self.refine
			self.select(
			:name, 
			:location,
			:phone_number,
			:fax_number,
			:email,
			:website).distinct
	end
end