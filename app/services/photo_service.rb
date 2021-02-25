require 'rest-client'
require 'jwt'

class PhotoService
  include TokenHelper

  def albums
    Rails.cache.fetch("albums", expires_in: 1.hour) do
      call(:get, '/v1/albums')['albums']
    end.map { |data| Album.find_or_create(data) }
  end

  def album(id)
    Album.find_or_create(
      Rails.cache.fetch("albums/#{id}", expires_in: 1.hour) do
        call(:get, "/v1/albums/#{id}")
      end
    )
  end

  def create_album_id(title)
    call(:post, '/v1/albums', {album: {title: title}})['id']
  end

  def album_photos(album)
    photos = Rails.cache.fetch("photos/album_#{album.id}", expires_in: 1.hour) do
      call(:post, '/v1/mediaItems:search', {album_id: album.external_id, page_size: "100"})['mediaItems']
    end
    photos ? photos.map { |data| Photo.find_or_create(data, album.id) } : []
  end

  def photo(id)
    Rails.cache.fetch("photos/#{id}", expires_in: 1.hour) do
      call(:get, "/v1/mediaItems/#{id}")
    end
  end

  private

  def call(method, path, params={})
    begin
      response = RestClient::Request.new({
        method: method,
        url: Rails.application.credentials.google[:library][:url] + path,
        headers: {'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json'},
        payload: params.to_json,
      }).execute
      JSON.parse(response.body)
    rescue RestClient::BadRequest => err
      raise err.response.body
    rescue RestClient::Unauthorized, ActiveSupport::MessageEncryptor::InvalidMessage
      refresh_access_token
      retry
    end
  end
end
