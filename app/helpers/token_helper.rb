module TokenHelper

  def access_token
    crypt.decrypt_and_verify(user.encrypted_token)
  end

  private

  def crypt
    @crypt ||= ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31])
  end

  def refresh_access_token
    response = RestClient.post "https://oauth2.googleapis.com/token", refresh_token_params
    token = JSON.parse(response.body)["access_token"]
    user.update!(encrypted_token: @crypt.encrypt_and_sign(token))
  end

  def refresh_token_params
    {
      client_id: Rails.application.credentials.google[:access][:client_id],
      client_secret: Rails.application.credentials.google[:access][:client_secret],
      refresh_token: refresh_token,
      grant_type: "refresh_token"
    }
  end

  def refresh_token
    @crypt.decrypt_and_verify(user.encrypted_refresh_token)
  end

  def user
    User.first
  end
end
