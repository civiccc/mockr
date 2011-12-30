module Authentication

  private # Should be included by controllers, inaccessible as :actions

  def viewer
    @viewer ||=
      User.find_by_facebook_uid(facebook_cookies[:user_id]) ||
      User.new(:facebook_uid => facebook_cookies[:user_id])
  end

  def facebook_cookies
    @facebook_cookies ||= FacebookCookies.new(cookies)
  end
end
