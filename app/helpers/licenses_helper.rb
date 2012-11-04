module LicensesHelper

  def status(license)
    case license.status
      when License::UNPROCESSED
        "Unprocessed"
      when License::ACTIVE
        "Active"
      when License::REJECTED
        "Rejected"
      when License::REMOVED
        "Removed"
      else
        "Unknown"
    end
  end
  
end
