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
    "fbs_#{FacebookConfig.app_id}"
  end

  def self.parse(str)
    return HashWithIndifferentAccess.new if str.blank?
    result = HashWithIndifferentAccess.new
    # The sub is just lchomp, if only that existed
    str.chomp('"').sub(/^"/, '').split('&').each do |kv|
      key, value = kv.split('=')
      result[key] = value
    end
    %w[expires uid].each {|key| result[key] = result[key].to_i}
    result
  end
end
