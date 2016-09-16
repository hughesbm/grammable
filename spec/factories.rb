FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "testuser#{n}@example.com"
    end
    password "testPassword"
    password_confirmation "testPassword"
  end
end
