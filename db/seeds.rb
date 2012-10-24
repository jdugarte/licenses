# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

main_dist = Distributor.create :name => 'Software Development', :main => true

User.create :name => 'Admin', :email => 'admin@local.com', :password => '123123', 
            :password_confirmation => '123123', :distributor_id => main_dist.id, 
            :admin => true
