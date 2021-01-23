require 'rest-client'
require 'jwt'

class PhotoService
  include TokenHelper

  def albums
    call(:get, '/v1/albums')['albums'].map { |data| Album.new(data) }
  end

  def album(id)
    data = call(:get, "/v1/albums/#{id}")
    Album.new(data)
  end

  def album_photos(id)
    call(:post, '/v1/mediaItems:search', {album_id: id})['mediaItems'].map { |data| Photo.new(data) }
  end

  private

  def call(method, path, params={})
    begin
      response = RestClient::Request.new({
        method: method,
        url: Rails.application.credentials.google[:library][:url] + path,
        headers: {:Authorization => "Bearer #{access_token}"},
        payload: params
      }).execute
      JSON.parse(response.body)
    rescue RestClient::Unauthorized, ActiveSupport::MessageEncryptor::InvalidMessage
      refresh_access_token
      retry
    end
  end
end
