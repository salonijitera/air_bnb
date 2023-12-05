class CheckoutInfo < ApplicationRecord
  validates :total_amount, :checkout_date, :status, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  enum status: { pending: 0, confirmed: 1, cancelled: 2 }
  def confirm
    self.status = 'confirmed'
    self.save
  end
end
