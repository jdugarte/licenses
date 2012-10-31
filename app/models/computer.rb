class Computer < ActiveRecord::Base

  validates :name, :presence => true

  belongs_to :client
  has_many   :licenses
  has_many :movements

  attr_accessible :name, :cpu, :hard_drive, :hd_volumen_serial, :motherboard_bios

end
