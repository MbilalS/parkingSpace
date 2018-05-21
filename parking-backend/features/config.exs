defmodule WhiteBreadConfig do
  use WhiteBread.SuiteConfiguration

  suite name:          "Search Available Parking",
        context:       WhiteBreadContext,
        feature_paths: ["features/parking_space_finding.feature"]
        
#   suite name:          "Start Parking",
#         context:       StartParkingContext,
#         feature_paths: ["features/payment_process.feature"]

end
