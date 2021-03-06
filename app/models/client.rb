class Client < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => { :scope => :distributor_id }
  validates :email, :presence => true

  attr_accessible :name, :email, :distributor_id
  
  belongs_to :distributor
  has_many :computers
  has_many :licenses, :through => :computers

  scope :requesting, joins(:licenses).where(:licenses => { :status => License::UNPROCESSED }).uniq

end
