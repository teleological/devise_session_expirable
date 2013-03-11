
class DeviseSessionExpirable::FailureApp < Devise::FailureApp

  def redirect_url
    flash[:timedout] = true if timeout?
    scope_path
  end

protected

  def warden_message
    @message ||=
      warden.message || warden_options[:message] || (timeout? ? :timeout : nil)
  end

  def timeout?
    !! env['devise.timeout']
  end

end

