class PhotosController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :find_photo, only: [:edit, :update]

  def update
    @photo.update!(photo_params)
  end

  private

  def find_album
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:author)
  end
end
