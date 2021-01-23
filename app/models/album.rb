class Album
  attr_reader :id, :title, :year, :river, :tags, :date, :cover_photo_url, :photo_count

  def initialize(data)
    @id = data["id"]
    @title_data = JSON.parse(data["title"]) if data["title"]
    @year = @title_data["rok"] if @title_data
    @river = @title_data["miejsce"] if @title_data
    @tags = @title_data["tagi"] if @title_data
    @date = @title_data["data"] if @title_data
    @title = [@year, @river, @tags, @date].join(" ")
    @cover_photo_url = data["coverPhotoBaseUrl"]
    @photo_count = data["mediaItemsCount"]
  end
end
