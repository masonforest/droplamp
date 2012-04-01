# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    site nil
    stripe_customer_token "MyString"
  end
end
