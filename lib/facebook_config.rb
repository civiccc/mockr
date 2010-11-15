class FacebookConfig
  CANVAS_BASE = "http://apps.facebook.com/"

  def self.method_missing(m)
    @config ||= begin
      cfg = YAML.load_file(File.join(Rails.root, "config", "facebook.yml"))
      cfg[Rails.env]
    end
    @config[m.to_s]
  end
end
