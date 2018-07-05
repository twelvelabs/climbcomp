FactoryBot.define do

  factory :user_identity do
    user
    email
    sequence(:sub) { |n| "auth0|#{n}" }
  end

end
