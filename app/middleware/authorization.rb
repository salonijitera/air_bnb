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
    if @request.path.include?('/api/users/') && @request.method == 'PUT'
      user_id = @request.path.split('/').last.to_i
      unless user_id == user.id
        return { error: 'Unauthorized to update this user profile', status: 401 }
      end
    end
    nil
  end
  def authorize_user(user_id)
    current_user_id = @request.headers['user_id']
    unless current_user_id == user_id
      return { error: 'User does not have permission to access the resource', status: 403 }
    end
    nil
  end
end
