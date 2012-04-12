# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.action_controller.session = {
    :session_key => '_mockr_session',
    :secret      => '21ee28b973e26bef6f112ae1807d3ff3eafeebadb1f0ccf70b098451ba139e24d5de6508045291bcca481317969c3852241ed097c1d2431d80407e268f74731e',
    :session_expires => Time.now + 31557600 #1.year not yet defined
  }

  config.action_mailer.default_url_options = {:host => (ENV['APP_HOST'] || "mockr")}
end
