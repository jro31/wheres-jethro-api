require 'rails_helper'

describe CheckInsRepresenter do
  let(:name_1) { 'Goodison Park' }
  let(:description_1) { 'Theatre of tears' }
  let(:latitude_1) { 53.43666492 }
  let(:longitude_1) { -2.959829494 }
  let(:accuracy_1) { 12.556 }
  let(:icon_1) { '🤮' }
  let(:time_zone_1) { 'Asia/Ujung_Pandang' }
  let(:created_at_1) { 2.days.ago }
  let!(:check_in_1) { create(:check_in, name: name_1, description: description_1, latitude: latitude_1, longitude: longitude_1, accuracy: accuracy_1, icon: icon_1, time_zone: time_zone_1, created_at: created_at_1) }

  let(:name_2) { 'Bangkok' }
  let(:latitude_2) { 13.7563 }
  let(:longitude_2) { 100.5018 }
  let(:created_at_2) { 1.day.ago }
  let!(:check_in_2) { create(:check_in, name: name_2, description: nil, latitude: latitude_2, longitude: longitude_2, accuracy: nil, icon: nil, time_zone: nil, created_at: created_at_2) }
  describe 'as_json' do
    subject { CheckInsRepresenter.new(CheckIn.all.order(created_at: :desc)).as_json }
    it 'returns the correct array' do
      expect(subject).to eq(
        [
          {
            id: check_in_2.id,
            name: name_2,
            description: nil,
            latitude: latitude_2,
            longitude: longitude_2,
            accuracy: nil,
            icon: nil,
            datetime: created_at_2,
            datetime_humanized: {
              date: created_at_2.strftime("#{created_at_2.day.ordinalize} %b '%y"),
              time: created_at_2.strftime('%H:%M UTC')
            },
            photo_url: nil
          },
          {
            id: check_in_1.id,
            name: name_1,
            description: description_1,
            latitude: latitude_1,
            longitude: longitude_1,
            accuracy: accuracy_1,
            icon: icon_1,
            datetime: created_at_1,
            datetime_humanized: {
              date: created_at_1.in_time_zone(time_zone_1).strftime("#{created_at_1.in_time_zone(time_zone_1).day.ordinalize} %b '%y"),
              time: created_at_1.in_time_zone(time_zone_1).strftime('%H:%M WITA')
            },
            photo_url: nil
          }
        ]
      )
    end
  end
end
