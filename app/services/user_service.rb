class UserService
  # Other methods...
  def create_profile(first_name, last_name, date_of_birth, profile_picture, user_id)
    raise 'Wrong format' unless user_id.is_a? Numeric
    raise 'The first name is required.' if first_name.blank?
    raise 'The last name is required.' if last_name.blank?
    begin
      Date.parse(date_of_birth)
    rescue ArgumentError
      raise 'The date of birth is not in valid format.'
    end
    user = User.find_by(id: user_id)
    raise 'User not found' unless user
    profile = UserProfile.new(
      first_name: first_name,
      last_name: last_name,
      date_of_birth: date_of_birth,
      profile_picture: profile_picture,
      user_id: user_id
    )
    if profile.save
      { 
        status: 200,
        profile: {
          id: profile.id,
          user_id: profile.user_id,
          first_name: profile.first_name,
          last_name: profile.last_name,
          date_of_birth: profile.date_of_birth,
          profile_picture: profile.profile_picture
        }
      }
    else
      raise profile.errors.full_messages.to_sentence
    end
  end
end
