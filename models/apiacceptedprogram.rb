require 'digest'
require 'digest/sha2'

class ApiAcceptedProgram < ActiveRecord::Base
	def validate_key?(key)
		return false if key.nil?
		sha256 = Digest::SHA256.new
		sha256.update key.to_s
		user = ApiAcceptedProgram.find_by_key(sha256.hexdigest.to_s)
		if user.nil?
			return false
		else
			if user.expires >= Date.today
				return true
			else
				return false
			end
		end
	end
end