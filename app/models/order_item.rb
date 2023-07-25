class OrderItem < ApplicationRecord
  belongs_to :album
  belongs_to :order

  before_save :calculate_sub_total

  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }

  private

  def calculate_sub_total
    self.sub_total = album.price * quantity
  end
end
