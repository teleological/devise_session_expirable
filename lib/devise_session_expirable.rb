
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/concern'
require 'devise'

module Devise #:nodoc:

  mattr_accessor :default_last_request_at
  @default_last_request_at = nil

  add_module :session_expirable,
    :model => 'devise_session_expirable/model'

end

module DeviseSessionExpirable #:nodoc:
end

