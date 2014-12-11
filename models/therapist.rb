require 'geocoder'
require "geocoder/railtie"
Geocoder::Railtie.insert

class Therapist < ActiveRecord::Base
	geocoded_by :postal_code

	def find_therapists(postal_code, distance, units)
		return [] if postal_code.nil?
		valid_therapists = Therapist.near(postal_code, distance.to_i, :units => units.to_sym)
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