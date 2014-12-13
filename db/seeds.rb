require 'sinatra/activerecord'
require './config/environments'
require './models/therapist'

Therapist.create(name: 'Test Therapist',
			location: '123 Fake St. NY NY 90210',
			postal_code: '90210',
			phone_number: '555-555-5555',
			fax_number: '555-555-5555',
			email: 'test@therapist.com',
			website: 'api.helpfinder.com',
			latitude: '34.103003200000000000',
			longitude: '-118.410468400000010000')

ApiUser.create(app_name: 'test_program',
						  key: "e35ed82c065c641eb2987acbd21ffb80508368d7cebdc509643f40c965172999",
						  expires: '2018-01-01')