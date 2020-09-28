FactoryBot.define do
  factory :favorite do
    association :book
    association :user
  end
end
