
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/concern'
require 'devise'

require 'devise_session_expirable/warden_extensions'
require 'devise_session_expirable/devise_extensions'

module DeviseSessionExpirable #:nodoc:
  autoload :Delegator,  'devise_session_expirable/delegator'
  autoload :FailureApp, 'devise_session_expirable/failure_app'
end

