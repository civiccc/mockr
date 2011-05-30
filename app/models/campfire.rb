class Campfire
  KEYS = ["campfire_subdomain", "campfire_token", "campfire_room"]

  def self.notify_mock_created(mock, url)
    options = {
      :ssl => true,
      :token => settings["campfire_token"]
    }
    campfire = Tinder::Campfire.new settings["campfire_subdomain"], options
    room = campfire.find_room_by_name(settings["campfire_room"])
    room.speak "#{mock.author.name} posted a new mock:"
    room.speak mock.image.url
    room.speak url
  end
  
  def self.settings
    @settings ||= begin
      settings = {}
      KEYS.each do |key|
        settings[key] = Setting.find_or_create_by_key(key).value
      end
      settings
    end
  end
end
