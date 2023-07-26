class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  validates :order_date, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validate :event_date_cannot_be_in_the_future

  private

  def event_date_cannot_be_in_the_future
    return unless order_date.present? && order_date > Date.today

    errors.add(:order_date, "Cannot be a future date")
  end
end
