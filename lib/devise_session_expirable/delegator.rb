
class DeviseSessionExpirable::Delegator < Devise::Delegator

  def failure_app(env)
    app = env["warden.options"] &&
      (scope = env["warden.options"][:scope]) &&
      Devise.mappings[scope.to_sym].failure_app

    app || DeviseSessionExpirable::FailureApp
  end

end

