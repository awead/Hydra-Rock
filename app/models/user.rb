class User < ActiveRecord::Base
  # Connects this user object to Blacklights Bookmarks. 
  include Blacklight::User
  include Hydra::User

  # Use PublicActivity to add user avtivities via the AF models, so don't track the user model here
  include PublicActivity::Model
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable identifier for
  # the account. 
  def to_s
    email
  end
end
