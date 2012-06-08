FactoryGirl.define do
  sequence :email do |n|
    "archivist#{n}@example.com"
  end

  factory :user do
    email
    password 'password'
  end

end
