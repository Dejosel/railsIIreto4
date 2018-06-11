class User < ActiveRecord::Base
	has_secure_token :api_token

	validates :email, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_initialize :generate_token

  private
    def generate_token
      self.api_token ||= SecureRandom.hex if new_record?
    end
end
