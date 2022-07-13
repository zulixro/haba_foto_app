class Album < ApplicationRecord
  extend FriendlyId

  has_many :photos, dependent: :destroy
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :places

  validates_presence_of :external_id
  friendly_id :external_id

  def self.find_or_create(data)
    album = self.find_or_create_by(external_id: data["id"]) do |album|
      album.title = data["title"]
    end
    album.update(cover_photo_url: data["coverPhotoBaseUrl"])
    album
  end

  def authors
    [author, photos.pluck(:author)].flatten.uniq.compact.join(", ")
  end

  def place_names
    places.pluck(:name).uniq.compact.join(", ")
  end
end
