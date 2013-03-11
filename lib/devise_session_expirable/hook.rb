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

