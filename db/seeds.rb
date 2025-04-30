# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a member if it doesn't existence
member = Member.find_or_create_by!(
  first_name: 'John',
  last_name: 'Doe',
  email: 'john_doe@omada.com'
)

# Ingest CSV data into the database

require 'csv'

csv_file_path = Rails.root.join('db', 'seeds', 'data', 'cgm_data_points.csv')


CSV.foreach(csv_file_path, headers: true) do |row|
  # Shape and normalize the data:
  # - value: to Integer; access by index because of duplicated header names
  # - tested_at: to DateTime; incorporate timezone offset
  #   NOTE: Still storing the tz_offset, in case this data is used in the future
  # - tz_offset: to String; remove gremlin unicode quotes; access by index because of duplicated header names

  tz_sanitized = row[2].tr('“”', '')
  tz_offset_string = tz_sanitized.empty? ? '-07:00' : tz_sanitized

  tested_at_string = [ row['tested_at'], tz_offset_string ].join(' ')
  tested_at_dt = DateTime.strptime(tested_at_string, '%m/%d/%y %k:%M %:z')

  p tested_at_dt

  row_parsed = {
    tested_at: tested_at_dt,
    value: row[1].to_i
  }

  # Create Level record, associated to +member+ for each row in the CSV file
  # Use find_or_create_by! to avoid duplicates
  Level.find_or_create_by!(
    member: member,
    value: row_parsed[:value],
    tested_at: row_parsed[:tested_at],
    tz_offset: tz_offset_string,
  )
end
