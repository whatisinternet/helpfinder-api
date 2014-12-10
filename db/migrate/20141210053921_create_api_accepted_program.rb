class CreateApiAcceptedProgram < ActiveRecord::Migration
  def up
  	create_table :api_accepted_programs do |t|
  		t.string :app_name
  		t.string :key
  		t.date   :expires
  	end
  end
 
  def down
  	drop_table :api_accepted_programs
  end
end