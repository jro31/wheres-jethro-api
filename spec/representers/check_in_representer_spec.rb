require 'rails_helper'

describe CheckInRepresenter do
  let(:name) { 'Goodison Park' }
  let(:description) { 'Theatre of tears' }
  let(:latitude) { 53.43666492 }
  let(:longitude) { -2.959829494 }
  let(:accuracy) { 12.556 }
  let(:icon) { '🤮' }
  let(:created_at) { 1.hour.ago }
  let!(:check_in) { create(:check_in, name: name, description: description, latitude: latitude, longitude: longitude, accuracy: accuracy, icon: icon, time_zone: time_zone, created_at: created_at) }
  describe 'as_json' do
    subject { CheckInRepresenter.new(check_in).as_json }
    context 'time_zone is included' do
      let(:time_zone) { 'Asia/Ujung_Pandang' }
      it 'returns the correct hash' do
        expect(subject).to eq(
          {
            id: check_in.id,
            name: name,
            description: description,
            latitude: latitude,
            longitude: longitude,
            accuracy: accuracy,
            icon: icon,
            datetime: created_at,
            datetime_humanized: {
              date: created_at.in_time_zone(time_zone).strftime("#{created_at.in_time_zone(time_zone).day.ordinalize} %b '%y"),
              time: created_at.in_time_zone(time_zone).strftime('%H:%M WITA')
            }
          }
        )
      end
    end

    context 'time_zone is not included' do
      let(:time_zone) { nil }
      it 'returns the correct hash' do
        expect(subject).to eq(
          {
            id: check_in.id,
            name: name,
            description: description,
            latitude: latitude,
            longitude: longitude,
            accuracy: accuracy,
            icon: icon,
            datetime: created_at,
            datetime_humanized: {
              date: created_at.strftime("#{created_at.day.ordinalize} %b '%y"),
              time: created_at.strftime('%H:%M UTC')
            }
          }
        )
      end
    end
  end
end
