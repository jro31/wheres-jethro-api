require 'rails_helper'

describe CheckInRepresenter do
  let(:name) { 'Goodison Park' }
  let(:description) { 'Theatre of tears' }
  let(:latitude) { 53.43666492 }
  let(:longitude) { -2.959829494 }
  let(:accuracy) { 12.556 }
  let(:icon) { '🤮' }
  let(:created_at) { 1.hour.ago }
  let!(:check_in) { create(:check_in, name: name, description: description, latitude: latitude, longitude: longitude, accuracy: accuracy, icon: icon, created_at: created_at) }
  describe 'as_json' do
    subject { CheckInRepresenter.new(check_in).as_json }
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
          datetime: created_at
        }
      )
    end
  end
end
