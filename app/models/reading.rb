class Reading < ApplicationRecord
  #Associations
  belongs_to :thermostat


  #Validations
  validates :number, presence: true, numericality: { only_integer: true }
  validates :temperature, presence: true, numericality: { only_float: true }
  validates :humidity, presence: true, numericality: { only_float: true }
  validates :battery_charge, presence: true, numericality: { only_float: true }


  def self.next_number
    Reading.connection.select_value("Select nextval('readings_id_seq')")
  end
end
