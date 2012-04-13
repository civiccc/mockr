Mockr::Application.configure do
  config.delivery_method = :smtp
  config.smtp_settings = {
    :enable_starttls_auto => true,
    :address              => 'smtp.gmail.com',
    :port                 => 587,
    :authentication       => 'plain',
    :user_name            => ENV['GMAIL_SMTP_USER'],
    :domain               => ENV['GMAIL_SMTP_DOMAIN'],
    :password             => ENV['GMAIL_SMTP_PASSWORD']
  }
end
