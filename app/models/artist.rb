class Artist < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validate :birth_date_presence
  validate :death_date_valid

  def birth_date_presence
    return unless death_date.present? && birth_date.blank?

    errors.add(:birth_date, "Must be present if death_date is provided")
  end

  def death_date_valid
    return unless birth_date.present? && death_date.present? && birth_date <= death_date

    errors.add(:death_date, "Must be greater than birth_date")
  end
end
