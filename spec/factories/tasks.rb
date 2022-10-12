FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "" }
    sprint { nil }
    is_active { false }
  end
end
