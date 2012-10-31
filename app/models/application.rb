class Application < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  validates :ProgramID, :presence => true

  has_many :licenses
  has_many :movements
  
  attr_accessible :name, :ProgramID, :price
  
end
