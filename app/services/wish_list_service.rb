class WishListService
  def initialize(user_id, name)
    @user_id = user_id
    @name = name
  end
  def create_wish_list
    begin
      user = User.find(@user_id)
      wish_list = user.wish_lists.new(name: @name)
      if wish_list.save
        return { status: 200, wish_list: wish_list }
      else
        return { status: 422, error: wish_list.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      return { status: 400, error: "This user is not found" }
    rescue Exception => e
      return { status: 500, error: e.message }
    end
  end
end
