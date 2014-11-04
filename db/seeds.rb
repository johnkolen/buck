# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
unless User.where(:email=>"admin@betuabuck.com").exists?
  admin = User.create!(:first_name=>"Admin",
                       :last_name=>"Admin",
                       :email=>"admin@betuabuck.com",
                       :is_admin=>true,
                       :credentials_attributes=>
                       [
                        {:password=>"conceptmoneyusers",
                          :password_confirmation=>"conceptmoneyusers"}
                       ])
end

