Feature: Parking payment
	As a customer
	Such that I pay for my parking
	Scenario: parking payment (under hourly scheme)
    	Given the following start times
    	| start_time         |
		| 2017-12-15 11:00:00|
		| 2017-12-15 11:00:00|
		| 2017-12-15 11:00:00|
		| 2017-12-15 11:00:00|
		
		And I am parked at "<point>"
		When I open the start page
		And select "<scheme>" payment scheme
		And enter "<leaving_time>"
		And press submit
		When I confirm the parking
		Then I should see a total amount of "<total>"
		And I pay
		Then I should see a "Successully paid" notification

	Scenario: parking payment (under real-time scheme)
		Given the following start times
		| start_time         |
		| 2017-12-15 11:00:00|
		| 2017-12-15 11:00:00|
		| 2017-12-15 11:00:00|
		| 2017-12-15 11:00:00|
		
		And I am parked at "<point>"
		When I open the start page
		And select "<scheme>" payment scheme
		And enter "<leaving_time>"
		And press submit
		When I confirm the parking
		Then I should see the status of my current parking
		When I click on end
		Then I should see a total amount of "<total>"
		And I pay
		Then I should see a "Successully paid" notification
	

		# Examples:
        # |point		        | scheme    | leaving_time        |  total  |
	    # |26.8238, 58.34524  | Hourly    | 2017-12-15 12:00:00 |  2      | 
	    # |26.8238, 58.34524  | Hourly    | 2017-12-15 12:00:00 |  1      | 
        # |26.8238, 58.34524  | REAL_TIME | 2017-12-15 12:00:00 |  1.16   | 
        # |26.8238, 58.34524  | REAL_TIME | 2017-12-15 12:00:00 |  0.80   | 