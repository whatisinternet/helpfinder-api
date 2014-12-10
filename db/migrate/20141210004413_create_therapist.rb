class CreateTherapist < ActiveRecord::Migration
  def up
  	create_table :therapists do |t|
  		t.string :name
  		t.string :location
  		t.string :postal_code
  		t.string :phone_number
  		t.string :fax_number
  		t.string :email
  		t.string :website
  		t.float  :latitude
  		t.float  :longitude
  	end
  end
 
  def down
  	drop_table :therapists
  end
end
