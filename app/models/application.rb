class Application < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  validates :ProgramID, :presence => true

  has_many :licenses
  
  attr_accessible :name, :ProgramID, :price
  
end
