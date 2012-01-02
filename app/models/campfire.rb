class Campfire
  KEYS = ["campfire_subdomain", "campfire_token", "campfire_room"]

  def self.notify_mocks_created(mocks, url)
    room = find_room
    if use? && room
      mock = mocks.first
      mocks_text = mocks.size == 1 ? "a new mock" : "#{mocks.size} new mocks"
      room.speak "#{mock.author.name} posted #{mocks_text}:"
      room.speak mock.image.url
      room.speak url
    end
  # Handle invalid token and invalid subdomain errors respectively.
  rescue Tinder::AuthenticationFailed, NoMethodError                
    # Do nothing.
  end

  def self.find_room
    campfire = Tinder::Campfire.new settings["campfire_subdomain"], self.options
    campfire.find_room_by_name(settings["campfire_room"])
  end

  def self.options
    {
      :ssl => true,
      :token => settings["campfire_token"]
    }
  end

  def self.settings
    settings = {}
    KEYS.each do |key|
      settings[key] = Setting[key]
    end
    settings
  end
  
  def self.use?
    !self.settings["campfire_subdomain"].blank?
  end
end
