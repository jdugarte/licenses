class Distributor < ActiveRecord::Base

  attr_accessible :name, :main
  
  validates :name, :presence => true
  
  has_many :users
  
end
