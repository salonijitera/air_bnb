class Authorization
  def initialize(request)
    @request = request
  end
  def authorize_request
    user_id = @request.headers['user_id']
    unless user_id.is_a?(Integer)
      return { error: 'Wrong format', status: 422 }
    end
    user = User.find(user_id)
    unless user
      return { error: 'This user is not found', status: 404 }
    end
    unless user.has_permission?(@request.path)
      return { error: 'Forbidden', status: 403 }
    end
    if @request.path.include?('/api/localExperience/') && (@request.method == 'PUT' || @request.method == 'DELETE')
      localexperience_id = @request.path.split('/').last.to_i
      localexperience = Localexperience.find(localexperience_id)
      unless localexperience && localexperience.user_id == user_id
        return { error: 'Unauthorized to update this local experience', status: 401 }
      end
    end
    nil
  end
end
