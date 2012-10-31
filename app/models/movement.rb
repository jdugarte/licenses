class Movement < ActiveRecord::Base

  attr_accessible :application_id, :computer_id, :sitecode, :mid, :activation_code, :removal_code, :hd_volumen_serial, :motherboard_bios, :cpu, :hard_drive, :notes, :removal_reason, :status, :processing_date, :user_id, :created_at, :updated_at, :license_id

  belongs_to :license
  belongs_to :application
  belongs_to :computer
  belongs_to :user

end
