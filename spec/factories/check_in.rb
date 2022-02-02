FactoryBot.define do
  factory :check_in do
    name { 'Goodison Park' }
    description { 'Theatre of tears' }
    latitude { 53.43666492 }
    longitude { -2.959829494 }
    accuracy { 12.556 }
    icon { '🤮' }
    time_zone { 'Asia/Ujung_Pandang' }
  end
end
