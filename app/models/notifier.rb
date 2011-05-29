class Notifier < ActionMailer::Base
  helper ApplicationHelper

  # TODO: fix this
  REPLY_TO = "do-not-reply@causes.com"

  def new_comment(comment)
    from REPLY_TO
    reply_to REPLY_TO
    subject comment.mock.default_subject
    recipients comment.recipient_emails
    content_type "text/html"
    body :comment => comment
  end  
  
  def new_mock(mock, recipients = nil)
    host = self.class.default_url_options[:host]

    from REPLY_TO
    recipients ||= Setting[:notification_email]
    reply_to REPLY_TO
    subject mock.default_subject
    recipients recipients
    attachment :body => mock.attachment_body,
               :content_type => "image/png",
               :filename => "#{mock.title}.png"
    part :body => render_message("new_mock", :host => host, :mock => mock),
         :content_type => "text/html"
  end
end
