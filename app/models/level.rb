class Level < ApplicationRecord
  belongs_to :member

  validates :level_type, presence: true, inclusion: { in: %w[continuous_glucose_monitoring] }
  validates :value, presence: true, numericality: { only_integer: true }
  validates :tested_at, presence: true
  validates :tz_offset, presence: true, format: { with: /\A[-+]\d{2}:\d{2}\z/, message: "must be in the format -07:00" }
  validates :unit, presence: true, inclusion: { in: %w[mg/dL] }

  def to_s
    "#{value} #{unit}"
  end
end
