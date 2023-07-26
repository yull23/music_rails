class Album < ApplicationRecord
  belongs_to :artist
  has_many :songs
  has_many :order_items
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :duration, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
