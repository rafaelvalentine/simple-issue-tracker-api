FactoryBot.define do
  factory :visitor_count do
    is_active { true }
    is_disabled { false }
    count { 1 }
  end
end
