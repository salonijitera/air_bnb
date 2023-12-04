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
  def update_profile(user_id, profile_params)
    return { status: 422, error: 'Wrong format' } unless user_id.is_a? Numeric
    user = User.find_by_id(user_id)
    return { status: 404, error: 'User not found' } unless user
    profile = user.user_profile
    return { status: 404, error: 'Profile not found' } unless profile
    validation_result = validate_profile_params(profile_params)
    return { status: 422, error: validation_result[:error] } unless validation_result[:valid]
    if profile.update(profile_params)
      { status: 200, profile: profile }
    else
      { status: 422, error: profile.errors.full_messages }
    end
  end
  private
  def validate_profile_params(params)
    errors = {}
    errors[:first_name] = 'The first name is required.' if params[:first_name].blank?
    errors[:last_name] = 'The last name is required.' if params[:last_name].blank?
    begin
      Date.parse(params[:date_of_birth]) if params[:date_of_birth]
    rescue ArgumentError
      errors[:date_of_birth] = 'The date of birth is not in valid format.'
    end
    { valid: errors.empty?, error: errors }
  end
end
