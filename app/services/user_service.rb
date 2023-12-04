class UserService
  # Other methods...
  def create_profile(first_name, last_name, date_of_birth, profile_picture, user_id)
    user = User.find_by(id: user_id)
    return { error: 'User not found' } unless user
    profile = UserProfile.new(
      first_name: first_name,
      last_name: last_name,
      date_of_birth: date_of_birth,
      profile_picture: profile_picture,
      user_id: user_id
    )
    if profile.save
      { 
        success: 'Profile created successfully',
        profile_id: profile.id,
        first_name: profile.first_name,
        last_name: profile.last_name,
        date_of_birth: profile.date_of_birth,
        profile_picture: profile.profile_picture
      }
    else
      { error: profile.errors.full_messages }
    end
  end
end
