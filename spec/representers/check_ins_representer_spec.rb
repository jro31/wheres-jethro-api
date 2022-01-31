require 'rails_helper'

describe CheckInsRepresenter do
  let(:name_1) { 'Goodison Park' }
  let(:description_1) { 'Theatre of tears' }
  let(:latitude_1) { 53.43666492 }
  let(:longitude_1) { -2.959829494 }
  let(:accuracy_1) { 12.556 }
  let!(:check_in_1) { create(:check_in, name: name_1, description: description_1, latitude: latitude_1, longitude: longitude_1, accuracy: accuracy_1, created_at: 2.days.ago) }

  let(:name_2) { 'Bangkok' }
  let(:latitude_2) { 13.7563 }
  let(:longitude_2) { 100.5018 }
  let!(:check_in_2) { create(:check_in, name: name_2, description: nil, latitude: latitude_2, longitude: longitude_2, accuracy: nil, created_at: 1.day.ago) }
  describe 'as_json' do
    subject { CheckInsRepresenter.new(CheckIn.all.order(created_at: :desc)).as_json }
    it 'returns the correct hash' do
      expect(subject).to eq(
        [
          {
            name: name_2,
            description: nil,
            latitude: latitude_2,
            longitude: longitude_2,
            accuracy: nil
          },
          {
            name: name_1,
            description: description_1,
            latitude: latitude_1,
            longitude: longitude_1,
            accuracy: accuracy_1
          }
        ]
      )
    end
  end
end
