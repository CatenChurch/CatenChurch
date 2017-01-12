class Oauth < ActiveRecord::Base
  belongs_to :user

  def self.find_or_create_user(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |oauth|
      if oauth.user.blank?
        puts "create user"
        oauth.create_user(email: auth.info.email, password: Devise.friendly_token[0,20])
      end
    end
  end

  def connect(u)
    update!(user: u)
  end

  def disconnect
    update!(user: nil)
  end
end
