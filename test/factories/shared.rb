FactoryBot.define do

  sequence :email do |n|
    "username-#{n}@example.com"
  end

end
