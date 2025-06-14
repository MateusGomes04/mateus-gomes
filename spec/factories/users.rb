FactoryBot.define do
  factory :user do
    display_name { Faker::Name.name }
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    company { create(:company) }
    password { "123456" }
    password_confirmation { "123456" }
    confirmed { true }
    confirmation_token { "t0k3n" }
  end
end
