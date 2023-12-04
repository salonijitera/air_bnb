class WishListValidator
  include ActiveModel::Validations
  validates :user_id, presence: { message: "This user is not found" }, numericality: { only_integer: true, message: "Wrong format" }
  validates :name, presence: { message: "The name is required." }, length: { maximum: 100, message: "You cannot input more 100 characters." }
  validate :user_id_exists_in_database
  def initialize(params = {})
    @user_id = params[:user_id]
    @name = params[:name]
    super
  end
  def user_id_exists_in_database
    errors.add(:user_id, "This user is not found") unless User.exists?(@user_id)
  end
end
