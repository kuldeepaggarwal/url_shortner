FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{ n }@example.com" }

    password 'pass1234'
    password_confirmation 'pass1234'
  end
end
