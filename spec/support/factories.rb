FactoryGirl.define do
  sequence :email do |n|
    # we'll use the same email for all the tests, for now...
    "archivist1@example.com"
  end

  factory :user do
    email
    password 'password'
  end

end
