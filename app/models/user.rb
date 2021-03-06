class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy

  #Follow associate
  has_many :active_relationships, class_name: "Relationship",
            foreign_key:"follower_id",
            dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
            foreign_key:"followed_id",
            dependent: :destroy
  has_many :following, through: :active_relationships,source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  #follow
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  #Unfollow
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  #if current_user follow -> true
  def following?(other_user)
    following.include?(other_user)
  end

  # favorite
  has_many :favorites, dependent: :destroy
  # comment
  has_many :book_comments, dependent: :destroy
  attachment :profile_image
  validates :name, presence: true, length: {minimum: 2, maximum: 20}
  validates :introduction, length: {maximum: 50}
end
