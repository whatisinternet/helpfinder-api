class RenameApiAcceptedProgram < ActiveRecord::Migration
  def self.up
    rename_table :api_accepted_programs, :api_users
  end 
  def self.down
    rename_table :api_users, :api_accepted_programs
  end
end
