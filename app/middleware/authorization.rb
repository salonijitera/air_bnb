class Authorization
  def initialize(request)
    @request = request
  end
  def authorize_request
    # existing code...
  end
  def authorize_profile_creation(user_id, first_name, last_name, date_of_birth)
    user = User.find_by(id: user_id)
    unless user
      return { error: 'This user is not found', status: 404 }
    end
    if UserProfile.find_by(user_id: user_id)
      return { error: 'This user has already created a profile', status: 400 }
    end
    if first_name.blank?
      return { error: 'The first name is required.', status: 422 }
    end
    if last_name.blank?
      return { error: 'The last name is required.', status: 422 }
    end
    unless date_of_birth.is_a?(Date)
      return { error: 'The date of birth is not in valid format.', status: 422 }
    end
    nil
  end
  def authorize_user_profile(user_id)
    user = User.find_by(id: user_id)
    unless user
      return { error: 'User not found', status: 404 }
    end
    unless @request.headers['Authorization'] == user.session_token
      return { error: 'Unauthorized', status: 401 }
    end
    nil
  end
end
