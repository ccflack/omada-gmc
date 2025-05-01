class Member < ApplicationRecord
  has_many :levels, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    full_name
  end

  def levels_for(type:)
    levels.where(level_type: type)
  end

  def scoped_levels_for(level_type:, date_scope:, date_range: nil)
    raise ArgumentError, "#{level_type} is an invalid level type" unless Level.level_types.include?(level_type)

    case date_scope
    when "last_7_days"
      levels.where(level_type: level_type).from_last_7_days
    when "month_to_date"
      levels_for(type: level_type).from_month_to_date
    when "range"
      levels_for(type: level_type).from_date_range(date_range[:start_date], date_range[:end_date])
    end
  end
end
