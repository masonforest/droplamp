Feature: New user creates site

  In order to host websites out of my Dropbox
  As a new user
  I want to create a domain on KISSr

  @dropbox_request
  Scenario: New user creates a site with a free domain on KISSr
    Given I am on the home page
    And I fill in "site[domain_attributes][domain]" with "mydomain" 
    And I select ".kissr.co" from "site_domain_attributes_tld"
	  And I press "Try it!"
    Then I should see "Sign Out"
    Then I should see "Mason Fischer"
    And I should see "mydomain.kissr.co"

  @javascript @dropbox_request
  Scenario: New user creates a site with a paid domain on KISSr
    Given I am on the home page
    And I fill in "site[domain_attributes][domain]" with "mydomain" 
    And I select ".com" from "site_domain_attributes_tld"
    And I press "Try it!"
    And I fill in "card_number" with "4242424242424242"
    And I fill in "card_code" with "123"
    And I select "1" from "card_month"
    And I select "2013" from "card_year"
    And I press "Purchase"
    Then I should see "Sign Out"
    Then I should see "Mason Fischer"
    And I should see "mydomain.com"


