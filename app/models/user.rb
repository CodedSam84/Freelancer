class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :full_name, presence: true
  validates :full_name, length: { maximum: 20 }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(full_name: data['name'],
        email: data['email'],
        password: Devise.friendly_token[0,20],
        image: data['image'],
        provider: access_token.provider,
        uid: access_token.uid
        # If you are using confirmable and the provider(s) you use validate emails, 
        # uncomment the line below to skip the confirmation emails.
        # user.skip_confirmation!
      )
    end
    user
  end

end
