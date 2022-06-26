class AlbumsController < ApplicationController
  before_action :find_album, only: [:show, :edit, :update, :edit_photos]

  def index
    @q = Album.where(id: photo_service.album_ids).ransack(params[:q])
    @albums = @q.result(distinct: true)
  end

  def show
    @photos = photo_service.album_photos(@album)
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(album_params.slice("title", "year", "author", "agreed_to_publish"))
    @album.external_id = photo_service.create_album_id(@album.title)
    if images.count > 30
      flash[:error] = 'Możesz dodać maksymalnie 30 zdjęć na wydarzenie, wybierz najlepsze'
      render :new
    elsif images.count < 1
      flash[:error] = 'Dodaj chociaż jedno zdjęcie'
      render :new

    elsif @album.save
      update_tags
      update_places
      add_images

      redirect_to @album
    else
      flash[:error] = "Coś się nie udało"
      render :new
    end
  end

  def edit
  end

  def update
    update_params = album_params.slice("title", "year", "author", "agreed_to_publish")
    @album.update!(update_params)

    update_tags
    update_places
    add_images

    redirect_to @album
  end

  private

  def find_album
    @album = Album.find(params[:id])
  end

  def photo_service
    @photo_service ||= PhotoService.new
  end

  def album_params
    params.require(:album).permit(:title, :year, :agreed_to_publish, :author, :tags, :places, images:[])
  end

  def update_tags
    unless tags.blank?
      @album.tags.delete_all
      tags.split(/[,\s]+/).each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        @album.tags << tag
      end
    end
  end

  def update_places
    unless places.blank?
      @album.places.delete_all
      places.split(/[,]+/).each do |place_name|
        place = Place.find_or_create_by(name: place_name)
        @album.places << place
      end
    end
  end

  def add_images
    tokens = images.map do |image|
      resized_image = MiniMagick::Image.new(image.tempfile.path).resize '1200x1200'
      photo_service.upload_token(resized_image.to_blob)
    end
    photo_service.add_media_items(tokens, @album.external_id)
    Rails.cache.delete("photos/album_#{@album.external_id}")
  end

  def images
    album_params["images"]
  end

  def places
    album_params["places"]
  end

  def tags
    album_params["tags"]
  end
end
