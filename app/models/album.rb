class Album < ApplicationRecord
  has_many :photos, dependent: :destroy
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :places

  validates_presence_of :external_id

  def self.find_or_create(data)
    self.find_or_create_by(external_id: data["id"]) do |album|
      album.title = data["title"]
      album.cover_photo_url = data["coverPhotoBaseUrl"]
    end
  end
end
