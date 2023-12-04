# == Schema Information
#
# Table name: notifications
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  message     :string
#  status      :string
#  user_id     :bigint
#  title       :string
#  description :text
#
class Notification < ApplicationRecord
  belongs_to :user
  validates :title, length: { maximum: 255 }, allow_nil: true
  validates :description, length: { maximum: 65535 }, allow_nil: true
end
