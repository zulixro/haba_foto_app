class Tag < ApplicationRecord
  validates_presence_of :name
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :photos
end
