class Computer < ActiveRecord::Base

  validates :name, :presence => true

  belongs_to :client

  attr_accessible :name, :cpu, :hard_drive, :hd_volumen_serial, :motherboard_bios

end
