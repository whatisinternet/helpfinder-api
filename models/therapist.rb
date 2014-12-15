require 'geocoder'
require "geocoder/railtie"
Geocoder::Railtie.insert

class Therapist < ActiveRecord::Base
	extend Geocoder::Model::ActiveRecord
	
	validates :name, presence: true
	validates :website, presence: true
	validates :postal_code, presence: true
	validates :location, presence: true

	validates :name, length: { minimum: 4 }
	validates :postal_code, length: { minimum: 4 }
	validates :location, length: { minimum: 4 }
	validates :website, length: { minimum: 4 }
	validates :email, length: { minimum: 4 }
	validates :phone_number, length: { minimum: 4 }
	validates :fax_number, length: { minimum: 4 }
	
	validates :email, format: { with: /\A^.+@.+$\z/}

	geocoded_by :location
	after_validation :geocode  

	def find_therapists(location, distance, units)
		return [] if location.nil?
		if units.downcase.to_s == 'km'
			valid_therapists = Therapist.near(location, distance.to_i, :units => :km)
		else
			valid_therapists = Therapist.near(location, distance.to_i, :units => :mi)
		end
		
	end

	def find_therapists_latlong(latitude, longitude, distance, units)
		return [] if latitude.nil? || longitude.nil?
		location = [latitude, longitude]
		find_therapists(location, distance, units)
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