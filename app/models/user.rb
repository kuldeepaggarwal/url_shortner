class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_many :tiny_urls, dependent: :destroy, as: :owner

  def build_tiny_url(attributes = {})
    tiny_urls.build(attributes)
  end
end
