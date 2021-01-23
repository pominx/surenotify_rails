class SandboxMailer < ActionMailer::Base
  def sandbox
    mail from: 'some@email.com', to: 'test@gmail.com', subject: 'this is an email'
  end
end
