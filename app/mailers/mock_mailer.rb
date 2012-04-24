class MockMailer < ActionMailer::Base

  def new_comment(comment)
    from "no-reply@#{ActionMailer::Base.smtp_settings[:domain]}"
    subject comment.mock.default_subject
    recipients comment.recipient_emails
    content_type "text/html"
    @comment = comment
    body
  end

  def new_mock(mock, recipients = nil)
    from "no-reply@#{ActionMailer::Base.smtp_settings[:domain]}"
    host = self.class.default_url_options[:host]

    recipients ||= Setting[:notification_email]
    subject mock.default_subject
    recipients recipients
    attachment :body => mock.attachment_body,
               :content_type => "image/png",
               :filename => "#{mock.title}.png"
    part :body => render_message("new_mock", :host => host, :mock => mock),
         :content_type => "text/html"
  end
end
