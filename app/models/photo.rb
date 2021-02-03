class Photo < ApplicationRecord
  belongs_to :album
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :places

  validates_presence_of :external_id

  def self.find_or_create(data, album_id)
    photo = self.find_or_create_by(external_id: data["id"]) do |photo|
      photo.date = data["mediaMetadata"]["creationTime"]
      photo.album_id = album_id
      Rails.cache.write("#{data["id"]}_url", "#{data["baseUrl"]}=w500-h500", expires_in: 1.hour)
    end
  end

  def url
    Rails.cache.fetch("#{external_id}_url", expires_in: 1.hour) do
      PhotoService.new.photo(external_id)["baseUrl"] + "=w500-h500"
    end
  end
end
