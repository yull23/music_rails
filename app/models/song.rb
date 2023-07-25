class Song < ApplicationRecord
  belongs_to :album
  validates :name, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0 }
end
