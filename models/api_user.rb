require 'digest'
require 'digest/sha2'

class ApiUser < ActiveRecord::Base
	validates :app_name, uniqueness: true
	validates :app_name, presence: true
	validates :app_name, length: { minimum: 4 }
	validates :key, uniqueness: true
	validates :key, presence: true
	validates :expires, presence: true

	def validate_key(key)
		return false if key.nil?
		user = get_user(key)
		if user.nil?
			return false
		else
			return validate_expire_date(user)
		end
	end

	def validate_expire_date(user)
		if user.expires >= Date.today
			return true
		else
			return false
		end
	end

	def get_user(key)
		ApiUser.find_by_key(hash_key(key))
	end

	def hash_key(key)
		sha256 = Digest::SHA256.new
		sha256.update key.to_s
		sha256.hexdigest.to_s
	end
end