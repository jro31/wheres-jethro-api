class CheckIn < ApplicationRecord
  has_one_attached :photo

  validates_presence_of :name, :latitude, :longitude
  # TODO - Validate that icon must be one emoji (that possible?)
end
