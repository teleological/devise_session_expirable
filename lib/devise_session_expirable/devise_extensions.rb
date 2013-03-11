
module Devise #:nodoc:

  mattr_accessor :default_last_request_at
  @default_last_request_at = nil

  add_module :session_expirable,
    :model => 'devise_session_expirable/model'

  def self.configure_warden! #:nodoc:
    warden_config.failure_app   = DeviseSessionExpirable::Delegator.new
    warden_config.default_scope = Devise.default_scope
    warden_config.intercept_401 = false

    Devise.mappings.each_value do |mapping|
      warden_config.scope_defaults mapping.name, :strategies => mapping.strategies
    end

    @@warden_config_block.try :call, Devise.warden_config
    true
  end

  class Mapping #:nodoc:

    private

    def default_failure_app(options)
      @failure_app = options[:failure_app] || DeviseSessionExpirable::FailureApp
      if @failure_app.is_a?(String)
        ref = Devise.ref(@failure_app)
        @failure_app = lambda { |env| ref.get.call(env) }
      end
    end

  end

end

