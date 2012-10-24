class Distributor < ActiveRecord::Base

  attr_accessible :name, :main
  
  validates :name, :presence => true
  validates :distributor_id, :presence => true, :unless  => :main?
  
  has_many :users
  belongs_to :parent, :foreign_key => "distributor_id", :class_name => "Distributor"
  has_many :distributors, :foreign_key => "distributor_id", :class_name => "Distributor"
  
end
