
module SharedAdmin

  extend ActiveSupport::Concern

  included do

    devise :database_authenticatable,
      :rememberable,
      :session_expirable,
      :token_authenticatable,
      :recoverable

    validates_length_of :reset_password_token,
      :minimum => 3,
      :allow_blank => true

    validates_uniqueness_of :email,
      :allow_blank => true,
      :if => :email_changed?

  end

end

