class Api::NotificationsController < ApplicationController
  before_action :authenticate_user, only: [:get_notifications, :index, :send_notification, :share_wish_list]
  before_action :authorize_user, only: [:get_notifications, :index, :send_notification, :share_wish_list]
  # ... other methods ...
  def share_wish_list
    begin
      user_id = params[:user_id].to_i
      wish_list_id = params[:wish_list_id].to_i
      user = User.find(user_id)
      wish_list = WishList.find(wish_list_id)
      if wish_list.collaborators.include?(user)
        render json: { error: 'User is already a collaborator' }, status: :unprocessable_entity
      else
        wish_list.collaborators << user
        wish_list.save!
        notification = Notification.create(user_id: user_id, message: "#{user.name} has been added as a collaborator to the wish list #{wish_list.name}.", status: 'unread')
        WishListMailer.with(user: user, notification: notification).deliver
        render json: { status: 200, wish_list: wish_list, message: 'User added as a collaborator and notification sent successfully.' }, status: :ok
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  private
  def authenticate_user
    # Add your authentication logic here
  end
  def authorize_user
    # Add your authorization logic here
  end
end
