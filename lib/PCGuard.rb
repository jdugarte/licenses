require 'win32ole'

class PCGuard
  
  attr_reader :activation_code, :removal_code, :hd_volumen_serial, 
              :motherboard_bios, :cpu, :hard_drive, :operating_system, :cd_dvd, 
              :network_card
  attr_accessor :programid, :sitecode, :mid, :features
  
  # "ResponseCode" values from PCGuard
  STATUS_OK = 0             # Success
  STATUS_BAD_SITE_CODE = 1  # Site code is invalid
  STATUS_BAD_PROGRAM_ID = 3 # ProgramID is invalid
  STATUS_BAD_MID_CODE = 6   # Machine ID is invalid
  STATUS_MID_CODE_ERROR = 7 # Machine ID decryption error
  
  # Exceptions
  class BadSiteCode < StandardError; end  
  class BadProgramID < StandardError; end  
  class BadMID < StandardError; end  
  class MIDCodeError < StandardError; end  
  
  def initialize(programid = "", sitecode = "", mid = "", features = 0)

    @programid = programid
    @sitecode  = sitecode
    @mid       = mid
    @features  = features

    @activation_code   = ""
    @removal_code      = ""
    @hd_volumen_serial = 0
    @motherboard_bios  = 0 
    @cpu               = 0
    @hard_drive        = 0
    @operating_system  = 0
    @cd_dvd            = 0
    @network_card      = 0
    
    self.generate unless (@programid.empty? || @sitecode.empty? || @mid.empty?)
    
  end
  
  def generate
    
    raise ArgumentError if (@programid.empty? || @sitecode.empty? || @mid.empty?)
    
    if Licenses::Application.config.generate_dummy_licenses
      l = DummyLicenseGenerator.new
    else
      l = WIN32OLE.new("icgweb.icgen")
    end
    
    # Validate machine codes
    l.ProgramID = @programid
    l.SiteCode  = @sitecode
    l.MachineID = @mid
    l.V5_CheckMachineID()
    unless l.ResponseCode == STATUS_OK
      raise BadSiteCode if l.ResponseCode == STATUS_BAD_SITE_CODE
      raise BadMID if l.ResponseCode == STATUS_BAD_MID_CODE
      raise MIDCodeError if l.ResponseCode == STATUS_MID_CODE_ERROR
    end
    
    # Generate codes
    l.SiteCode  = @sitecode
    l.MachineID = @mid
    l.Features  = @features
    l.V5_CalculateActivationCode()
    unless l.ResponseCode == STATUS_OK
      raise BadSiteCode if l.ResponseCode == STATUS_BAD_SITE_CODE
      raise BadProgramID if l.ResponseCode == STATUS_BAD_PROGRAM_ID
      raise BadMID if l.ResponseCode == STATUS_BAD_MID_CODE
    end
    
    # Resulting codes and IDs
    @activation_code   = l.ActivationCode
    @removal_code      = l.RemoveCode
    @hd_volumen_serial = l.DriveID.to_i
    @motherboard_bios  = l.BiosID.to_i
    @cpu               = l.CPUID.to_i
    @hard_drive        = l.HDHWID.to_i
    @operating_system  = l.OSID.to_i
    @cd_dvd            = l.CDHWID.to_i
    @network_card      = l.NETID.to_i
    
    # Return activation code
    @activation_code
    
  end
  
end

class DummyLicenseGenerator

  attr_accessor :ProgramID, :SiteCode, :MachineID, :Features
  
  def initialize
    @ProgramID = ""
    @SiteCode  = ""
    @MachineID = ""
    @Features  = 0
  end
  
  def V5_CheckMachineID; end
  def V5_CalculateActivationCode; end
  def ResponseCode
    @SiteCode[0].to_i
  end
  
  def ActivationCode
    "XXXXXXXX-XXXXXXXX-XXXXXXXX-XXXXXXXX"
  end
  def RemoveCode
    "XXXXXXXX"
  end

  def BiosID
    @MachineID.split(",")[0]
  end
  def CPUID
    @MachineID.split(",")[1]
  end
  def HDHWID
    @MachineID.split(",")[2]
  end
  def DriveID ; 0 ; end
  def OSID ; 0 ; end
  def CDHWID ; 0 ; end
  def NETID ; 0 ; end
  
end