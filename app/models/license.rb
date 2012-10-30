require 'PCGuard'

class License < ActiveRecord::Base
  
  # statuses
  UNPROCESSED = 1
  ACTIVE = 2
  REJECTED = 3
  REMOVED = 4
  TRANSFERRING = 5
  
  validates :sitecode, :mid, :status, :presence => true
  validates :computer_id, :uniqueness => { :scope => :application_id }
  
  after_initialize :init
  
  belongs_to :application
  belongs_to :computer
  belongs_to :user

  attr_accessible :sitecode, :mid, :activation_code, :removal_code, :removal_reason, :hd_volumen_serial, :motherboard_bios, :cpu, :hard_drive, :notes, :status, :processing_date, :user
  
  class AlreadyProcessed < StandardError; end
  class NotActive < StandardError; end
  class IncorrectRemovalCode < StandardError; end
  class ComputerNotRegistered < StandardError; end
  
  def init
    self.status = UNPROCESSED if new_record?
  end
  
  # status?
  def unprocessed?
    status == UNPROCESSED
  end
  def active?
    status == ACTIVE
  end
  def rejected?
    status == REJECTED
  end
  def removed?
    status == REMOVED
  end
  def transferring?
    status == TRANSFERRING
  end
  
  # process license
  def approve!
    raise AlreadyProcessed if status != UNPROCESSED
    self.update_attribute(:status, ACTIVE) if self.valid?
  end
  def reject!
    raise AlreadyProcessed if status != UNPROCESSED
    self.update_attribute(:status, REJECTED) if self.valid?
  end
  
  def renew(new_sitecode, new_mid, new_user, new_notes = "")
    raise ArgumentError if new_sitecode.blank? or new_mid.blank? or new_user.nil?
    raise NotActive unless active?
    
    l = PCGuard.new(application.ProgramID, new_sitecode, new_mid)

    raise ComputerNotRegistered if motherboard_bios.nonzero? != l.motherboard_bios and cpu.nonzero? != l.cpu and hard_drive.nonzero? != l.hard_drive
    
    # mov = GenerarMovimientoHistorico()

    computer.assign_attributes motherboard_bios: l.motherboard_bios, cpu: l.cpu, 
      hard_drive: l.hard_drive, hd_volumen_serial: l.hd_volumen_serial
    self.assign_attributes sitecode: new_sitecode, mid: new_mid, notes: new_notes, user: new_user, 
      activation_code: l.activation_code, removal_code: l.removal_code, cpu: l.cpu, 
      motherboard_bios: l.motherboard_bios, hard_drive: l.hard_drive, 
      hd_volumen_serial: l.hd_volumen_serial
    
    License.transaction do
      # mov.save!
      computer.save!
      self.save!
    end
  end

  def remove(given_removal_code, user_removing, reason = "")
    
    raise ArgumentError if given_removal_code.blank? or user_removing.nil?
    raise NotActive unless active?
    raise IncorrectRemovalCode unless removal_code == given_removal_code
    
    # mov = GenerarMovimientoHistorico()
    self.assign_attributes status: REMOVED, removal_reason: reason, user: user_removing
    License.transaction do
      # mov.save!
      self.save!
    end
    
  end

end
