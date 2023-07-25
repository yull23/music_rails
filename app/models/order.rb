class Order < ApplicationRecord
  belongs_to :user
  validates :order_date, presence: true
  validates :total, presence: true, numericality: { greater_than: 0 }
  validate :event_date_cannot_be_in_the_future

  private

  def event_date_cannot_be_in_the_future
    return unless order_date.present? && order_date > Date.today

    errors.add(:order_date, "Cannot be a future date")
  end
end
