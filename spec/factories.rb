FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "testuser#{n}@example.com"
    end
    password "testPassword"
    password_confirmation "testPassword"
  end

  factory :gram do
    message "hello"
    association :user
  end
end
