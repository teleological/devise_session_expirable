
# Each time the user record is fetched from a session, the record is
# consulted (via +#session_expired?+) to determine if the
# +last_request_at+ time in the session is valid, or if the session
# should be considered as having timed out. This validation is not
# performed if +devise.skip_timeout+ is set in the rack environment.
#
# If the session is deemed to have timed out, the record is logged out
# of the session and a +:timeout+ message is thrown, invoking the
# +FailureApp+.
#
# Unlike the Devise +timeoutable+ module, devise_session_expirable does
# not support invalidation of authentication tokens from the devise
# +token_authenticatable+ module when a request with a valid
# authentication token is accompanied by an expired session.

Warden::Manager.after_fetch do |record, warden, options|
  scope = options[:scope]
  env = warden.request.env

  if record                               &&
    record.respond_to?(:session_expired?) &&
    warden.authenticated?(scope)          &&
    options[:store] != false              &&
    !env['devise.skip_timeout']

    last_request_at = warden.session(scope)['last_request_at']
    if record.session_expired?(last_request_at)
      warden.logout(scope)
      throw :warden, :scope => scope, :message => :timeout
    end
  end
end

# Each time the user record is set, the +last_request_at+ time
# is updated in the scoped session. This update is not performed if
# devise.skip_trackable is set in the rack environment.

Warden::Manager.after_set_user do |record, warden, options|
  scope = options[:scope]
  env = warden.request.env

  if record                               &&
    record.respond_to?(:session_expired?) &&
    warden.authenticated?(scope)          &&
    options[:store] != false              &&
    !env['devise.skip_trackable']

    warden.session(scope)['last_request_at'] = Time.now.utc
  end
end

