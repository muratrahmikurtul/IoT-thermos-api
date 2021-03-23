require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  let(:object) { FactoryBot.create(:thermostat) }

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
      it { should validate_presence_of(:household_token) }
      it { should validate_presence_of(:location) }
      it { should validate_uniqueness_of(:household_token) }
    end

  end

end
