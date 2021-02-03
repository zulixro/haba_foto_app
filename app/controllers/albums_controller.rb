class AlbumsController < ApplicationController
  before_action :find_album, only: [:show, :edit, :update, :edit_photos]

  def index
    @albums = photo_service.albums
  end

  def show
    @photos = photo_service.album_photos(@album)
  end

  def edit
  end

  def update
    update_params = album_params.slice("title", "year", "author", "start_date", "end_date", "agreed_to_publish")
    @album.update!(update_params)

    update_tags
    update_places
    update_author if album_params["update_photo_authors"]

    redirect_to @album
  end

  def edit_photos
  end

  private

  def find_album
    @album = Album.find(params[:id])
  end

  def photo_service
    @photo_service ||= PhotoService.new
  end

  def album_params
    params.require(:album).permit(:title, :year, :start_date, :end_date, :agreed_to_publish, :author, :update_photo_authors, :tags, :places)
  end

  def update_tags
    if tags = album_params["tags"]
      @album.tags.delete_all
      tags = tags.split(/[,\s]+/)
      tags.each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        @album.tags << tag
        @album.photos.each { |photo| photo.tags << tag unless photo.tags.include?(tag) }
      end
    end
  end

  def update_places
    if places = album_params["places"]
      @album.places.delete_all
      places = places.split(/[,\s]+/)
      places.each do |place_name|
        place = Place.find_or_create_by(name: place_name)
        @album.places << place
        @album.photos.each { |photo| photo.places << place unless photo.places.include?(place) }
      end
    end
  end

  def update_author
    if author = album_params["author"]
      @album.photos.update_all(author: author)
    end
  end
end
