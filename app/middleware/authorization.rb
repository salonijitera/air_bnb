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
    # Check if the request is to delete a local experience
    if @request.path.include?('localexperiences') && @request.method == 'DELETE'
      localexperience = Localexperience.find(@request.params[:id])
      # Check if the user is the owner of the local experience
      unless localexperience && localexperience.user_id == user_id
        return { error: 'Forbidden', status: 403 }
      end
      # Check if the id is not a number
      unless @request.params[:id].is_a?(Integer)
        return { error: 'Wrong format.', status: 422 }
      end
      # Check if the id is not found in the database
      unless Localexperience.exists?(@request.params[:id])
        return { error: 'This local experience is not found.', status: 404 }
      end
    end
    nil
  end
  def authorize_local_experience_create
    user_id = @request.headers['user_id']
    unless user_id.is_a?(Integer)
      return { error: 'Wrong format', status: 422 }
    end
    user = User.find(user_id)
    unless user
      return { error: 'This user is not found', status: 404 }
    end
    unless @request.path == '/api/localExperience' && @request.method == 'POST'
      return { error: 'Forbidden', status: 403 }
    end
    nil
  end
end
