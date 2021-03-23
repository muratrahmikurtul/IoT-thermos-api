class ReadingsController < ApplicationController
  before_action :authenticate_thermostat
  before_action :check_params, only: :create

  def index
  end

  def create
    $redis.set(@number, params)
    CreateReadingWorker.perform_async(@number, @thermostat.id, @temperature, @humidity, @battery_charge)
    render json: {number: @number, status: 202}, status: :accepted
  end

  def show
    reading = $redis.get(params[:id]) || Reading.find_by(number: params[:id])
    render json: { message: "Data not found with this Number" } and return unless reading
    render json: reading
  end

  def stats
  end

  private

  def authenticate_thermostat
    token = params[:household_token]
    render json: { message: 'Please provide household token.', status: 401 }, status: 401 and return unless token
    @thermostat = Thermostat.find_by(household_token: token)
    render json: { message: 'Household token is invalid !', status: 401 }, status: 401 and return unless @thermostat
  end

  def check_params
    if %w(temperature humidity battery_charge).all? {|key| params[key].present?}
      @temperature = params[:temperature]
      @humidity = params[:humidity]
      @battery_charge = params[:battery_charge]
      @number = Reading.next_number
      reading = Reading.new(reading_params.merge!(thermostat_id: @thermostat.id, number: @number))
      render json: { errors: reading.errors } and return if reading.invalid?
    else
      render json: { message: 'Bad request please check parameters', status: 400 }, status: :bad_request
    end
  end


  def reading_params
    params.permit(:temperature, :humidity, :battery_charge)
  end
end
