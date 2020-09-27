FactoryBot.define do
  factory :book do
    name { "座右の銘" }
    thoughts { "いろいろな人の考えが載っていて、とても勉強になります" }
    association :user
    created_at { Time.current }
  end

  trait :yesterday do
    created_at { 1.day.ago }
  end

  trait :one_week_ago do
    created_at { 1.week.ago }
  end

  trait :one_month_ago do
    created_at { 1.month.ago }
  end
end


