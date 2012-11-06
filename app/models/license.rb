require 'PCGuard'

class License < ActiveRecord::Base
  
  # statuses
  UNPROCESSED = 1
  ACTIVE = 2
  REJECTED = 3
  REMOVED = 4
  
  validates :application_id, :computer_id, :sitecode, :mid, :status, :presence => true
  validate :only_one_active_license_per_computer
  validates_associated :application, :computer

  after_initialize :init
  
  belongs_to :application
  belongs_to :computer
  belongs_to :user
  has_many :movements
  
  scope :active, where(:status => ACTIVE)
  scope :unprocessed, where(:status => UNPROCESSED).joins(:computer).order(:client_id)
  
  attr_accessible :sitecode, :mid, :activation_code, :removal_code, :removal_reason, :hd_volumen_serial, :motherboard_bios, :cpu, :hard_drive, :notes, :status, :processing_date, :user, :user_id, :computer, :computer_id, :application, :application_id

  # Virtual attributes, to handle new license form
  attr_accessor :client_id
  attr_accessible :client_id
  
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
  
  # process license
  def approve!
    raise AlreadyProcessed if status != UNPROCESSED
    self.update_attribute(:status, ACTIVE) if self.valid?
  end
  def self.approve!(ids)
    self.where(:id => ids, :status => UNPROCESSED).update_all(:status => ACTIVE)
  end
  def reject!
    raise AlreadyProcessed if status != UNPROCESSED
    self.update_attribute(:status, REJECTED) if self.valid?
  end
  def self.reject!(ids)
    self.where(:id => ids, :status => UNPROCESSED).update_all(:status => REJECTED)
  end
  
  def renew(new_sitecode, new_mid, user_renewing, new_notes = "")

    raise ArgumentError if new_sitecode.blank? or new_mid.blank? or user_renewing.nil?
    raise NotActive unless active?
    
    l = PCGuard.new(application.ProgramID, new_sitecode, new_mid)

    check_computer_ids computer, l
    
    movement = archive()
    computer.assign_attributes motherboard_bios: l.motherboard_bios, cpu: l.cpu, 
      hard_drive: l.hard_drive, hd_volumen_serial: l.hd_volumen_serial
    self.assign_attributes sitecode: new_sitecode, mid: new_mid, notes: new_notes, user: user_renewing, 
      activation_code: l.activation_code, removal_code: l.removal_code, cpu: l.cpu, 
      motherboard_bios: l.motherboard_bios, hard_drive: l.hard_drive, 
      hd_volumen_serial: l.hd_volumen_serial
    
    License.transaction do
      movement.save!
      computer.save!
      self.save!
    end
    
  end

  def remove(given_removal_code, user_removing, reason = "")
    
    raise ArgumentError if given_removal_code.blank? or user_removing.nil?
    raise NotActive unless active?
    raise IncorrectRemovalCode unless removal_code == given_removal_code
    
    movement = archive()
    self.assign_attributes status: REMOVED, removal_reason: reason, user: user_removing

    License.transaction do
      movement.save!
      self.save!
    end
    
  end

  def transfer(new_computer, given_removal_code, new_sitecode, new_mid, user_trans, new_notes = "")
  
    raise ArgumentError if new_computer.nil? or given_removal_code.blank? or new_sitecode.blank? or new_mid.blank? or user_trans.nil?
    raise NotActive unless active?
    raise IncorrectRemovalCode unless removal_code == given_removal_code

    l = PCGuard.new(application.ProgramID, new_sitecode, new_mid)

    check_computer_ids new_computer, l
    
    movement = archive()
    new_computer.assign_attributes motherboard_bios: l.motherboard_bios, cpu: l.cpu, 
      hard_drive: l.hard_drive, hd_volumen_serial: l.hd_volumen_serial
    self.assign_attributes sitecode: new_sitecode, mid: new_mid, notes: new_notes, 
      computer: new_computer, user: user_trans, activation_code: l.activation_code, 
      removal_code: l.removal_code, cpu: l.cpu, motherboard_bios: l.motherboard_bios, 
      hard_drive: l.hard_drive, hd_volumen_serial: l.hd_volumen_serial
    
    License.transaction do
      movement.save!
      new_computer.save!
      self.save!
    end
      
  end
    
  def self.search(search) 
    if search 
      where('notes LIKE ?', "%#{search}%") 
    else 
      scoped 
    end 
  end

  private
  
  def only_one_active_license_per_computer
    unless removed? or rejected?
      if License.exists? ["application_id = ? AND computer_id = ? AND status NOT IN (?, ?) AND id != ?", application_id, computer_id, REMOVED, REJECTED, id.to_i]
        errors.add( :computer_id, 'already has an active license for this application')
      end
    end
  end  

  def check_computer_ids(comp, lic)
    if comp.motherboard_bios.nonzero? != lic.motherboard_bios and 
       comp.cpu.nonzero? != lic.cpu and 
       comp.hard_drive.nonzero? != lic.hard_drive
      raise ComputerNotRegistered
    end
  end
  
  def archive()
    Movement.new self.attributes.except('id').merge({"license_id" => id})
  end

end
