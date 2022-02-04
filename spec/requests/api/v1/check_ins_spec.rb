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
      let(:time_zone_1) { 'Asia/Ujung_Pandang' }
      let(:created_at_1) { 2.days.ago }
      let!(:check_in_1) { create(:check_in, name: name_1, description: description_1, latitude: latitude_1, longitude: longitude_1, accuracy: accuracy_1, icon: icon_1, time_zone: time_zone_1, created_at: created_at_1) }

      let(:name_2) { 'Bangkok' }
      let(:latitude_2) { 13.7563 }
      let(:longitude_2) { 100.5018 }
      let(:created_at_2) { 1.day.ago }
      let!(:check_in_2) { create(:check_in, name: name_2, description: nil, latitude: latitude_2, longitude: longitude_2, accuracy: nil, icon: nil, time_zone: nil, created_at: created_at_2) }
      it 'returns the check-ins' do
        get url

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          'check_ins' => [
            {
              'id' => check_in_2.id,
              'name' => name_2,
              'description' => nil,
              'latitude' => latitude_2,
              'longitude' => longitude_2,
              'accuracy' => nil,
              'icon' => nil,
              'datetime' => created_at_2.as_json,
              'datetime_humanized' => {
                'date' => created_at_2.strftime("#{created_at_2.day.ordinalize} %b '%y"),
                'time' => created_at_2.strftime('%H:%M UTC')
              },
              'photo_url' => nil
            },
            {
              'id' => check_in_1.id,
              'name' => name_1,
              'description' => description_1,
              'latitude' => latitude_1,
              'longitude' => longitude_1,
              'accuracy' => accuracy_1,
              'icon' => icon_1,
              'datetime' => created_at_1.as_json,
              'datetime_humanized' => {
                'date' => created_at_1.in_time_zone(time_zone_1).strftime("#{created_at_1.in_time_zone(time_zone_1).day.ordinalize} %b '%y"),
                'time' => created_at_1.in_time_zone(time_zone_1).strftime('%H:%M WITA')
              },
              'photo_url' => nil
            }
          ]
        })
      end

      context 'limit is passed in the params' do
        let(:url) { '/api/v1/check_ins?limit=1' }
        it 'returns the most recent check-in' do
          get url

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq({
            'check_ins' => [
              {
                'id' => check_in_2.id,
                'name' => name_2,
                'description' => nil,
                'latitude' => latitude_2,
                'longitude' => longitude_2,
                'accuracy' => nil,
                'icon' => nil,
                'datetime' => created_at_2.as_json,
                'datetime_humanized' => {
                  'date' => created_at_2.strftime("#{created_at_2.day.ordinalize} %b '%y"),
                  'time' => created_at_2.strftime('%H:%M UTC')
                },
                'photo_url' => nil
              }
            ]
          })
        end
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
    let(:time_zone) { 'Asia/Ujung_Pandang' }
    let(:url) { '/api/v1/check_ins' }
    let(:params) { { check_in: { name: name, description: description, latitude: latitude, longitude: longitude, accuracy: accuracy, icon: icon, time_zone: time_zone } } }
    let(:expected_return) {
      {
        'check_in' => {
          'id' => CheckIn.last.id,
          'name' => name,
          'description' => description,
          'latitude' => latitude,
          'longitude' => longitude,
          'accuracy' => accuracy,
          'icon' => icon,
          'datetime' => CheckIn.last.created_at.as_json,
          'datetime_humanized' => {
            'date' => CheckIn.last.created_at.in_time_zone(time_zone).strftime("#{CheckIn.last.created_at.in_time_zone(time_zone).day.ordinalize} %b '%y"),
            'time' => CheckIn.last.created_at.in_time_zone(time_zone).strftime('%H:%M %Z')
          },
          'photo_url' => nil
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
          let(:params) { { check_in: { description: description, latitude: latitude, longitude: longitude, accuracy: accuracy, icon: icon, time_zone: time_zone } } }
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
          let(:params) { { check_in: { name: name, latitude: latitude, longitude: longitude, accuracy: accuracy, icon: icon, time_zone: time_zone } } }
          it 'creates a new check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(1)
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end

        context 'latitude is not present' do
          let(:params) { { check_in: { name: name, description: description, longitude: longitude, accuracy: accuracy, icon: icon, time_zone: time_zone } } }
          it 'does not create a check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(0)
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({
              'error_message' => 'Latitude can\'t be blank'
            })
          end
        end

        context 'longitude is not present' do
          let(:params) { { check_in: { name: name, description: description, latitude: latitude, accuracy: accuracy, icon: icon, time_zone: time_zone } } }
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
          let(:params) { { check_in: { name: name, description: description, latitude: latitude, longitude: longitude, icon: icon, time_zone: time_zone } } }
          it 'creates a new check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(1)
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end

        context 'icon is not present' do
          let(:icon) { nil }
          let(:params) { { check_in: { name: name, description: description, latitude: latitude, longitude: longitude, accuracy: accuracy, time_zone: time_zone } } }
          it 'creates a new check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(1)
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end

        context 'time_zone is not present' do
          let(:time_zone) { nil }
          let(:params) { { check_in: { name: name, description: description, latitude: latitude, longitude: longitude, accuracy: accuracy, icon: icon } } }
          it 'creates a new check-in' do
            expect { post url, params: params }.to change { CheckIn.count }.by(1)
            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)).to eq(expected_return)
          end
        end

        context 'photo is present' do
          # TODO
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
