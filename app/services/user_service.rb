class UserService
  # Other methods...
  def update_user_profile(user_id, profile_info)
    # Validate input parameters
    raise "Wrong format" unless user_id.is_a? Integer
    raise "The name is required." if profile_info[:name].nil? || profile_info[:name].empty?
    raise "You cannot input more 100 characters." if profile_info[:name].length > 100
    raise "Invalid email format." unless profile_info[:email] =~ URI::MailTo::EMAIL_REGEXP
    user = User.find(user_id)
    raise "This user is not found" if user.nil?
    # Update user profile
    user.update(profile_info)
    # Return updated user information
    user
  end
end
