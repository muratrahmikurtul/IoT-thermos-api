require 'rails_helper'

RSpec.describe Reading, type: :model do
  let(:object) { FactoryBot.create(:reading) }

  before do
    expect(object).to be_persisted
  end

  describe 'validations' do
    context 'defaults' do
      it 'valid' do
        expect(object).to be_valid
      end
    end

    context 'ActiveModel' do
      it { should validate_presence_of(:number) }
      it { should validate_presence_of(:temperature) }
      it { should validate_presence_of(:humidity) }
      it { should validate_presence_of(:battery_charge) }
      it { should validate_uniqueness_of(:number) }
    end
  end

  describe 'class methods' do
    it 'return next_number' do
      next_number = Reading.next_number
      expect(next_number).to eq(object.id.to_i + 1)
    end
  end

end
