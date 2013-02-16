
require 'devise_session_expirable/hook'

module Devise #:nodoc:
  module Models #:nodoc:

    # SessionExpirable verifies whether a user session has expired
    # via the +#session_expired?+ method.
    #
    # == Options
    #
    # SessionExpirable adds the following options to devise_for:
    #
    # * +timeout_in+: lifetime in seconds of an inactive user session
    # * +default_last_request_at+: age to assume for sessions with nil +last_request_at+
    #
    # == Examples
    #
    #   user.session_expired?(30.minutes.ago)
    #

    module SessionExpirable

      extend ActiveSupport::Concern

      # Accepts the time a session was last used and compares it
      # to the oldest valid +last_request_at+ date for a session.
      # If nil or any other falsy value is passed and the
      # +default_last_request_at+ option is configured, the configured
      # value will be used for the comparison.
      #
      # Supports the Devise +rememberable+ module by deferring to
      # +#remember_expired?+ if the +remember_created_at+ attribute
      # is set.

      def session_expired?(last_access)
        last_access ||= default_last_request_at
        return false if remember_exists_and_not_expired?
        !timeout_in.nil? && (!last_access || last_access <= timeout_in.ago)
      end

      def timeout_in
        self.class.timeout_in
      end

      def default_last_request_at
        self.class.default_last_request_at
      end

      #:nodoc:
      def self.required_fields(klass); []; end

      private

      def remember_exists_and_not_expired?
        return false unless respond_to?(:remember_created_at)
        remember_created_at && !remember_expired?
      end

      module ClassMethods #:nodoc:

        Devise::Models.config self,
          :timeout_in,
          :default_last_request_at

      end

    end

  end
end

