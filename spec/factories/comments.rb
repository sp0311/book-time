FactoryBot.define do
  factory :comment do
    user_id { 1 }
    content { "第３章まで 読了" }
    association :book
  end
end