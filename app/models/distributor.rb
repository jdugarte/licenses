class Distributor < ActiveRecord::Base

  validates :name, :presence => true
#  validates :distributor_id, :presence => true, :unless  => :main?
  
  has_many :users
  belongs_to :parent, :foreign_key => "distributor_id", :class_name => "Distributor"
  has_many :distributors, :foreign_key => "distributor_id", :class_name => "Distributor"
  
  attr_accessible :name, :main, :users_attributes
  accepts_nested_attributes_for :users
  
  MAIN        = 1
  MASTER      = 2
  DISTRIBUTOR = 3
  
  def type
    if main?
      MAIN
    elsif parent.main?
      MASTER
    else
      DISTRIBUTOR
    end
  end
  
  def master?
    !parent.nil? and parent.main?
  end
  
  def dist?
    !main? and !master?
  end
  
end
