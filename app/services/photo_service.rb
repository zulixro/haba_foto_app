require 'rest-client'
require 'jwt'

class PhotoService
  include TokenHelper

  def albums
    begin
      response = RestClient.get photo_url + "/v1/albums", {:Authorization => "Bearer #{access_token}"}
      JSON.parse(response.body)["albums"]
    rescue RestClient::Unauthorized, ActiveSupport::MessageEncryptor::InvalidMessage
      refresh_access_token
      retry
    end
  end

  private

  def photo_url
    Rails.application.credentials.google[:library][:url]
  end
end
