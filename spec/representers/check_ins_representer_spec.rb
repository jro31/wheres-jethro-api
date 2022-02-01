require 'rails_helper'

describe CheckInsRepresenter do
  let(:name_1) { 'Goodison Park' }
  let(:description_1) { 'Theatre of tears' }
  let(:latitude_1) { 53.43666492 }
  let(:longitude_1) { -2.959829494 }
  let(:accuracy_1) { 12.556 }
  let(:icon_1) { '🤮' }
  let(:created_at_1) { 2.days.ago }
  let!(:check_in_1) { create(:check_in, name: name_1, description: description_1, latitude: latitude_1, longitude: longitude_1, accuracy: accuracy_1, icon: icon_1, created_at: created_at_1) }

  let(:name_2) { 'Bangkok' }
  let(:latitude_2) { 13.7563 }
  let(:longitude_2) { 100.5018 }
  let(:created_at_2) { 1.day.ago }
  let!(:check_in_2) { create(:check_in, name: name_2, description: nil, latitude: latitude_2, longitude: longitude_2, accuracy: nil, icon: nil, created_at: created_at_2) }
  describe 'as_json' do
    subject { CheckInsRepresenter.new(CheckIn.all.order(created_at: :desc)).as_json }
    it 'returns the correct array' do
      expect(subject).to eq(
        [
          {
            name: name_2,
            description: nil,
            latitude: latitude_2,
            longitude: longitude_2,
            accuracy: nil,
            icon: nil,
            datetime: created_at_2
          },
          {
            name: name_1,
            description: description_1,
            latitude: latitude_1,
            longitude: longitude_1,
            accuracy: accuracy_1,
            icon: icon_1,
            datetime: created_at_1
          }
        ]
      )
    end
  end
end
