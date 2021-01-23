class AlbumsController < ApplicationController

  def index
    @albums = photo_service.albums
  end

  def show
    @album = photo_service.album(params[:id])
    @photos = photo_service.album_photos(params[:id])
  end

  private

  def photo_service
    @photo_service ||= PhotoService.new
  end
end
