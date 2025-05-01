class Level < ApplicationRecord
  TYPES = %w[continuous_glucose_monitoring].freeze
  UNITS = %w[mg/dL].freeze
  DATE_SCOPES = %w[last_7_days month_to_date].freeze

  belongs_to :member

  validates :level_type, presence: true, inclusion: { in: TYPES }
  validates :value, presence: true, numericality: { only_integer: true }
  validates :tested_at, presence: true
  validates :tz_offset, presence: true, format: { with: /\A[-+]\d{2}:\d{2}\z/, message: "must be in the format -07:00" }
  validates :unit, presence: true, inclusion: { in: UNITS }

  scope :from_last_7_days, -> {
    where(tested_at: (Time.zone.now.beginning_of_day - 6.days)..Time.zone.now.end_of_day)
  }
  scope :from_month_to_date, -> {
    where(tested_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
  }
  scope :from_date_range, ->(start_date, end_date) {
    where(tested_at: start_date..end_date)
  }

  scope :above_threshold, ->(threshold) { where("value > ?", threshold) }
  scope :below_threshold, ->(threshold) { where("value < ?", threshold) }
  scope :in_range, ->(min, max) { where("value >= ? AND value <= ?", min, max) }

  def self.level_types
    TYPES
  end

  def self.units
    UNITS
  end

  def self.date_scopes
    DATE_SCOPES
  end

  def to_s
    "#{value} #{unit}"
  end
end
