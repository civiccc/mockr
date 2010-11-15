AWS_W3_CONFIG_FILE = "config/aws-s3.yml"
PAPERCLIP_STORAGE_OPTIONS = if File.exists?(AWS_W3_CONFIG_FILE)
  {
    :storage => :s3,
    :s3_credentials => "config/aws-s3.yml",
    :path => ":attachment/:id/:style/:basename.:extension"
  }
else
  {
    :url  => "/mocks/:id/:basename-:style.:extension",
    :path => ":rails_root/public/mocks/:id/:basename-:style.:extension"
  }
end
