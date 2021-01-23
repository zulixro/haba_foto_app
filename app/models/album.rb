class Album
  attr_reader :id, :title, :cover_photo_url, :photo_count

  def initialize(data)
    @id = data["id"]
    @title = data["title"]
    @cover_photo_url = data["coverPhotoBaseUrl"]
    @photo_count = data["mediaItemsCount"]
  end
end
