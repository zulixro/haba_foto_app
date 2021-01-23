class AlbumsController < ApplicationController

  def index
    @albums = PhotoService.new.albums.map { |data| Album.new(data) }
  end
end
