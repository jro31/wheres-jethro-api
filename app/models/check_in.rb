class CheckIn < ApplicationRecord
  has_one_attached :photo

  validates_presence_of :name, :latitude, :longitude
end
