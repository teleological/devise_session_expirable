
module SharedUser

  extend ActiveSupport::Concern

  included do

    devise :database_authenticatable,
      :rememberable,
      :session_expirable,
      :token_authenticatable

    attr_accessible :username,
      :email,
      :password,
      :password_confirmation,
      :remember_me

  end

end

