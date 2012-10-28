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

  attr_accessible :sitecode, :mid, :activacion_code, :removal_code, :hd_volumen_serial, :motherboard_bios, :cpu, :hard_drive, :notes, :removal_reason, :status, :processing_date
  
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
    self.update_attribute(:status, ACTIVE)
  end
  def reject!
    raise AlreadyProcessed if status != UNPROCESSED
    self.update_attribute(:status, REJECTED)
  end
  
end
