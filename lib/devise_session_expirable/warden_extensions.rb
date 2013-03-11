
# Each time the user record is fetched from a session, the record is
# consulted (via +#session_expired?+) to determine if the
# +last_request_at+ time in the session is valid, or if the session
# should be considered as having timed out. If the session is deemed
# to have timed out, the record is disregarded.
#
# Unlike the Devise +timeoutable+ module, devise_session_expirable does
# not support invalidation of authentication tokens from the devise
# +token_authenticatable+ module when a request with a valid
# authentication token is accompanied by an expired session.

class Warden::SessionSerializer

  def fetch(scope)
    key = session[key_for(scope)]
    return nil unless key

    method_name = "#{scope}_deserialize"
    user = respond_to?(method_name) ? send(method_name, key) : deserialize(key)
    user = nil unless valid_for_deserialization?(scope, user)
    delete(scope) unless user
    user
  end

  private

  def valid_for_deserialization?(scope, user)
    ! validate_session_expiration(scope, user)
  end

  def validate_session_expiration(scope, user)
    is_expired = false
    if user && user.respond_to?(:session_expired?)
      last_request_at = session_for_scope(scope)['last_request_at']
      is_expired = user.session_expired?(last_request_at)
    end
    env['devise.timeout'] = is_expired
  end

  def session_for_scope(scope)
    session["warden.user.#{scope}.session"] ||= {}
  end

end

