Given /^a user exists with email "([^"]*)" and uid "([^"]*)"$/ do | email, uid |
  User.create(:email => email, :uid => uid )
end

