require 'rest-client'
require 'jwt'

class PhotoService
  include TokenHelper

  def albums
    Rails.cache.fetch("albums", expires_in: 1.hour) do
      response = JSON.parse(call(:get, '/v1/albums'))
      response['albums']
    end.map { |data| Album.find_or_create(data) }
  end

  def album(id)
    Album.find_or_create(
      Rails.cache.fetch("albums/#{id}", expires_in: 1.hour) do
        JSON.parse(call(:get, "/v1/albums/#{id}"))
      end
    )
  end

  def create_album_id(title)
    response = call(:post, '/v1/albums', {album: {title: title}}.to_json)
    JSON.parse(response)['id']
  end

  def album_photos(album)
    photos = Rails.cache.fetch("photos/album_#{album.id}", expires_in: 1.hour) do
      response = call(:post, '/v1/mediaItems:search', {album_id: album.external_id, page_size: "100"}.to_json)
      JSON.parse(response)['mediaItems']
    end
    photos ? photos.map { |data| Photo.find_or_create(data, album.id) } : []
  end

  def photo(id)
    Rails.cache.fetch("photos/#{id}", expires_in: 1.hour) do
      JSON.parse(call(:get, "/v1/mediaItems/#{id}"))
    end
  end

  def upload_token(binary_data)
    call(:post, "/v1/uploads", binary_data, 'application/octet-stream')
  end

  def add_media_items(tokens, album_extarnal_id)
    payload = {
      album_id: album_extarnal_id,
      new_media_items: tokens.map { |token| { simple_media_item: { upload_token: token } } }
    }.to_json

    call(:post, "/v1/mediaItems:batchCreate", payload)
  end

  private

  def call(method, path, payload=nil, content_type='application/json')
    data = {
      method: method,
      url: Rails.application.credentials.google[:library][:url] + path,
      headers: {'Authorization' => "Bearer #{access_token}", 'Content-Type' => content_type}
    }
    data.merge!({ payload: payload }) if payload

    begin
      response = RestClient::Request.new(data).execute
      response.body
    rescue RestClient::BadRequest => err
      raise err.response.body
    rescue RestClient::Unauthorized
      refresh_access_token
      retry
    end
  end
end
