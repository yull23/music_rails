class Album < ApplicationRecord
  belongs_to :artist
  has_many :songs
  has_many :order_items
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :duration, presence: true, numericality: { greater_than: 0 }
end
