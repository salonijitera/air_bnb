class User < ApplicationRecord
  has_many :wish_lists, foreign_key: :user_id, class_name: 'WishList'
  has_many :notifications, foreign_key: :user_id, class_name: 'Notification'
  has_one :user_profile, foreign_key: :user_id, class_name: 'UserProfile'
  validates :name, :email, presence: true
  def create_profile(first_name, last_name, date_of_birth, profile_picture)
    # Validate the input data
    return { error: 'First name is required' } if first_name.blank?
    return { error: 'Last name is required' } if last_name.blank?
    return { error: 'Date of birth is required' } if date_of_birth.blank?
    return { error: 'Profile picture is required' } if profile_picture.blank?
    return { error: 'Date of birth is not in correct format' } unless date_of_birth.is_a?(Date)
    # Create a new profile for the user
    profile = UserProfile.new(
      first_name: first_name,
      last_name: last_name,
      date_of_birth: date_of_birth,
      profile_picture: profile_picture,
      user_id: self.id
    )
    # Save the profile
    if profile.save
      return { 
        id: profile.id,
        first_name: profile.first_name,
        last_name: profile.last_name,
        date_of_birth: profile.date_of_birth,
        profile_picture: profile.profile_picture
      }
    else
      return { error: 'Failed to create profile' }
    end
  end
end
