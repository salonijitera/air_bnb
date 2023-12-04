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
  def validate_add_property(wish_list_id, property_id)
    unless WishList.exists?(wish_list_id)
      errors.add(:wish_list_id, "This wish list does not exist")
    end
    unless Property.exists?(property_id)
      errors.add(:property_id, "This property does not exist")
    end
    if WishListItem.exists?(wish_list_id: wish_list_id, property_id: property_id)
      errors.add(:base, "This property is already in the wish list")
    end
    if errors.any?
      raise ActiveModel::ValidationError.new(self)
    end
  end
end
