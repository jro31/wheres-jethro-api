FactoryBot.define do
  factory :check_in, aliases: [:check_in_without_photo] do
    name { 'Goodison Park' }
    description { 'Theatre of tears' }
    latitude { 53.43666492 }
    longitude { -2.959829494 }
    accuracy { 12.556 }
    icon { '🤮' }
    time_zone { 'Asia/Ujung_Pandang' }

    factory :check_in_with_photo do
      after(:create) { |check_in| check_in.photo.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'test_photo.jpg')),
        filename: 'test_photo.jpg',
        content_type: 'image/jpeg'
      ) }
    end
  end
end
