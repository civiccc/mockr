class FacebookCookies
  def initialize(cookies)
    @cookies = self.class.parse(cookies[self.class.fb_cookie_key])
  end

  def inspect
    @cookies.inspect
  end

  def [](name)
    return nil unless @cookies
    @cookies[name]
  end

  def self.fb_cookie_key
    "fbsr_#{FacebookConfig.app_id}"
  end

  def self.parse(raw_sr)
    return {} if raw_sr.blank?

    signature, encoded_json = raw_sr.split('.')
    json = base64_url_decode(encoded_json)
    data = nil

    begin
      data = ActiveSupport::JSON.decode(json)
    rescue ActiveSupport::JSON::ParseError
      # Facebook sometimes passes us bad JSON.
      json += json.last == '"' ? '}' : '"}'
      data = ActiveSupport::JSON.decode(json) rescue {}
    end

    (valid_signed_request?(json, signature) ? data : {}).with_indifferent_access
  end

private

  def self.base64_url_decode(encoded)
    encoded += '=' * (4 - encoded.length.modulo(4))
    Base64.decode64(encoded.tr('-_', '+/'))
  end

  def self.base64_url_encode(plain)
    Base64.encode64(plain).tr('+/', '-_').delete("\n=")
  end

  def self.valid_signed_request?(json, signature)
    payload = base64_url_encode(json)
    mysig = OpenSSL::HMAC.digest('sha256', FacebookConfig.secret, payload)
    base64_url_encode(mysig) == signature
  end
end
