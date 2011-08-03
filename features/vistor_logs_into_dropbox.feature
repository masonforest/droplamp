Feature: Login via Dropbox

  In order to give KISSr access to my Dropbox file
  As a visitor
  I want to login via Dropbox

  Scenario: Visitor logs in via Dropbox
	Given I am on the home page
	And I follow "Login to Dropbox"
	Then I should see "Hi, Mason!"

