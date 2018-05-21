Feature: Search Available Parking
  As a customer
  Such that I go to destination
  I want to find available parking space in the area 
  Scenario Outline: Finding a parking slot (with confirmation)
    Given I want to go to "<destination>"
        And I open the FindMeAParkingSpace application
        And I enter my destination address
        When I summit the request
        Then I should be to view available places on a map

		Examples:
             | destination        | 
			 | Uueturu 2          | 
			 | Ulikooli 18        |
             | Raatuse 22         | 
