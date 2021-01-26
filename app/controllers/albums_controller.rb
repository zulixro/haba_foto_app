class AlbumsController < ApplicationController

  def index
    @albums = photo_service.albums
  end

  def show
    @album = Album.find(params[:id])
    @photos = photo_service.album_photos(@album)
  end

  private

  def photo_service
    @photo_service ||= PhotoService.new
  end
end
