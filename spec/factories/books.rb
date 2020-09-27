FactoryBot.define do
  factory :book do
    name { "座右の銘" }
    thoughts { "いろんな人の考え方が載っていて、とても勉強になります" }
    association :user
  end
end
