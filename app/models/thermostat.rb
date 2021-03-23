class Thermostat < ApplicationRecord
  #Associations
  has_many :readings, dependent: :destroy

  # Validations
  validates :household_token, presence: true, uniqueness: true
  validates :location, presence: true
end
