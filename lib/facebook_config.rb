class FacebookConfig
  CANVAS_BASE = "http://apps.facebook.com/"
  CONFIG_FILE = File.join(Rails.root, "config", "facebook.yml")

  def self.method_missing(m)
    @config ||= begin
      YAML::load(ERB.new(File.read(CONFIG_FILE)).result)
    end
    @config[m.to_s]
  end
end
