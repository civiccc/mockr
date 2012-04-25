class MockMailer < ActionMailer::Base
  def new_comment(comment)
    from "no-reply@#{ActionMailer::Base.smtp_settings[:domain]}"
    subject comment.mock.default_subject
    recipients comment.recipient_emails
    content_type "text/html"
    @comment = comment
    body
  end
end
