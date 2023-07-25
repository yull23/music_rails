class Order < ApplicationRecord
  belongs_to :user
  validates :order_date, presence: true
  validates :total, presence: true, numericality: { greater_than: 0 }
end
