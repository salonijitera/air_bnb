class UserIdValidator
  def self.validate(user_id)
    raise "This user is not found" if User.find_by(id: user_id).nil?
    raise "Wrong format" unless user_id.is_a? Integer
  end
end
