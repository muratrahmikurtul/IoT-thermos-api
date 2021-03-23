require 'rails_helper'

RSpec.describe ReadingsController, type: :controller do
  let(:reading) { create(:reading) }
  let(:thermostat) { create(:thermostat) }

  describe 'POST /readings' do
    context 'household_token not present' do
      it "return authenticate_thermostat message" do
        post :create, params: { temperature: "35.4", humidity: "18", battery_charge: "150" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to eq('Please provide household token.')
      end
    end

    context 'household_token is invalid' do
      it "return authenticate_thermostat message" do
        post :create, params: { household_token: 'abc', temperature: "25.4", humidity: "46", battery_charge: "4645" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to eq('Household token is invalid')
      end
    end

    context 'household_token is valid but params are missing' do
      it "return errors message" do
        post :create, params: { household_token: thermostat.household_token, battery_charge: "2345" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to eq('Bad request please check parameters')
      end
    end

    context 'household_token is valid but params type are wrong' do
      it "return errors message" do
        post :create, params: { household_token: thermostat.household_token, humidity: "sdf", battery_charge: "ertgf" }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to eq('Bad request please check parameters')
      end
    end

    context 'household_token is valid and all params present' do
      it "return accept" do
        post :create, params: { household_token: thermostat.household_token, temperature: "35.4", humidity: "18", battery_charge: "4564"}
        expect(response).to have_http_status(202)
      end
    end
  end

  describe 'GET /readings/:id' do
    context 'household_token not present' do
      it "return authenticate_thermostat message" do
        get :show, params: { id: reading.id }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["message"]).to eq('Please provide household token.')
      end
    end

    context 'household_token present' do
      it "provide a reading for a thermostat" do
        get :show, params: { household_token: thermostat.household_token, id: reading.id }
        expect(response).to have_http_status(200)
      end
    end
  end
end