require 'rails_helper'

describe CheckIn, type: :model do
  subject { create(:check_in) }
  it { expect(subject).to be_valid }

  describe 'associations' do
    describe 'has_one_attached :photo' do
      context 'photo is attached' do
        subject { create(:check_in_with_photo) }
        it { expect(subject.photo.attached?).to eq(true) }
      end

      context 'photo is not attached' do
        subject { create(:check_in_without_photo) }
        it { expect(subject.photo.attached?).to eq(false) }
      end
    end
  end

  describe 'validations' do
    describe 'name' do
      let(:name) { 'Goodison Park' }
      subject { build(:check_in, name: name) }
      it { expect(subject).to be_valid }
      describe 'validates presence of name' do
        context 'name is not present' do
          let(:name) { nil }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:name]).to include('can\'t be blank')
          end
        end
      end
    end

    describe 'latitude' do
      let(:latitude) { 53.43666492 }
      subject { build(:check_in, latitude: latitude) }
      it { expect(subject).to be_valid }
      describe 'validates presence of latitude' do
        context 'latitude is not present' do
          let(:latitude) { nil }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:latitude]).to include('can\'t be blank')
          end
        end
      end
    end

    describe 'longitude' do
      let(:longitude) { -2.959829494 }
      subject { build(:check_in, longitude: longitude) }
      it { expect(subject).to be_valid }
      describe 'validates presence of longitude' do
        context 'longitude is not present' do
          let(:longitude) { nil }
          it 'is invalid with the correct error' do
            expect(subject).not_to be_valid
            expect(subject.errors.messages[:longitude]).to include('can\'t be blank')
          end
        end
      end
    end
  end
end
