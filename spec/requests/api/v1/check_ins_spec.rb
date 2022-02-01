require 'rails_helper'

describe 'check_ins API', type: :request do
  describe 'GET /api/v1/check_ins' do
    let(:url) { '/api/v1/check_ins' }
    context 'check-ins exist' do
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
      it 'returns the check-ins' do
        get url

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          'check_ins' => [
            {
              'name' => name_2,
              'description' => nil,
              'latitude' => latitude_2,
              'longitude' => longitude_2,
              'accuracy' => nil,
              'icon' => nil,
              'datetime' => created_at_2.as_json
            },
            {
              'name' => name_1,
              'description' => description_1,
              'latitude' => latitude_1,
              'longitude' => longitude_1,
              'accuracy' => accuracy_1,
              'icon' => icon_1,
              'datetime' => created_at_1.as_json
            }
          ]
        })
      end
    end

    context 'no check-ins exist' do
      it 'returns an empty array' do
        get url

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          'check_ins' => []
        })
      end
    end
  end

  describe 'POST /api/v1/check_ins' do
    let(:name) { 'Goodison Park' }
    let(:description) { 'Theatre of tears' }
    let(:latitude) { 53.43666492 }
    let(:longitude) { -2.959829494 }
    let(:accuracy) { 12.556 }
    let(:icon) { '🤮' }
    let(:url) { '/api/v1/check_ins' }
    let(:params) { { check_in: { name: name, description: description, latitude: latitude, longitude: longitude, accuracy: accuracy, icon: icon } } }
    let(:expected_return) {
      {
        'check_in' => {
          'name' => name,
          'description' => description,
          'latitude' => latitude,
          'longitude' => longitude,
          'accuracy' => accuracy,
          'icon' => icon,
          'datetime' => CheckIn.last.created_at.as_json
        }
      }
    }
    context 'user is logged-in' do
      context 'user is permitted' do
        include_context 'login'
        context 'all fields are present' do
          it 'creates a new check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(1)
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end

        context 'name is not present' do
          let(:params) { { check_in: { description: description, latitude: latitude, longitude: longitude, accuracy: accuracy, icon: icon } } }
          it 'does not create a check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(0)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
              'error_message' => 'Name can\'t be blank'
            })
          end
        end

        context 'description is not present' do
          let(:description) { nil }
          let(:params) { { check_in: { name: name, latitude: latitude, longitude: longitude, accuracy: accuracy, icon: icon } } }
          it 'creates a new check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(1)
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end

        context 'latitude is not present' do
          let(:params) { { check_in: { name: name, description: description, longitude: longitude, accuracy: accuracy, icon: icon } } }
          it 'does not create a check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(0)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
              'error_message' => 'Latitude can\'t be blank'
            })
          end
        end

        context 'longitude is not present' do
          let(:params) { { check_in: { name: name, description: description, latitude: latitude, accuracy: accuracy, icon: icon } } }
          it 'does not create a check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(0)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
              'error_message' => 'Longitude can\'t be blank'
            })
          end
        end

        context 'accuracy is not present' do
          let(:accuracy) { nil }
          let(:params) { { check_in: { name: name, description: description, latitude: latitude, longitude: longitude, icon: icon } } }
          it 'creates a new check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(1)
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end

        context 'icon is not present' do
          let(:icon) { nil }
          let(:params) { { check_in: { name: name, description: description, latitude: latitude, longitude: longitude, accuracy: accuracy } } }
          it 'creates a new check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(1)
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end
      end

      context 'user is not permitted' do
        include_context 'login_imposter'
        it 'does not create a check-in' do
          expect { post url, params: params }.to change { CheckIn.count }.by(0)
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq({
            'error_message' => 'Unauthorized CheckInPolicy.create?'
          })
        end
      end
    end

    context 'user is not logged-in' do
      it 'does not create a check-in' do
        expect { post url, params: params }.to change { CheckIn.count }.by(0)
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({
          'error_message' => 'Unauthorized CheckInPolicy.create?'
        })
      end
    end
  end
end