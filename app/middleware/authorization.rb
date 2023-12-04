class Authorization
  def initialize(request)
    @request = request
  end
  def authorize_request
    # existing code...
  end
  def authorize_profile_creation(user_id)
    user = User.find_by(id: user_id)
    unless user
      return { error: 'This user is not found', status: 404 }
    end
    if UserProfile.find_by(user_id: user_id)
      return { error: 'This user has already created a profile', status: 400 }
    end
    nil
  end
end
