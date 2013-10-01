FactoryGirl.define do

  factory :user, :class => User do |u|
    email 'archivist1@example.com'
    password 'password'
  end

end
