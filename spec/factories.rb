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
    picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.png'), 'image/png') }
    association :user
  end
end
