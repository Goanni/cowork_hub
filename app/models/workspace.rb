class Workspace < ApplicationRecord
  self.inheritance_column = nil
  
  WORK_START_HOUR = 7
  WORK_END_HOUR = 22

  belongs_to :zone
  has_many :rates, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :workspace_amenities, dependent: :destroy
  has_many :amenities, through: :workspace_amenities
  has_many :workspace_equipment, dependent: :destroy
  has_many :equipment, through: :workspace_equipment

  validates :name, presence: true, uniqueness: { scope: :zone_id }
  validates :type, presence: true, inclusion: { in: %w[desk meeting_room conference_room] }
  validates :capacity, presence: true, numericality: { greater_than: 0 }

  def find_best_rate(start_time, end_time)
    return nil if start_time.blank? || end_time.blank?
    
    booking_hours = (end_time - start_time) / 1.hour
    days_diff = (end_time.to_date - start_time.to_date).to_i + 1
    work_hours = WORK_END_HOUR - WORK_START_HOUR

    if days_diff == 1
      if booking_hours >= work_hours
        daily_rate = rates.includes(:rate_type).find { |r| r.rate_type.name == "День" }
        return daily_rate if daily_rate
      else
        hourly_rate = rates.includes(:rate_type).find { |r| r.rate_type.duration_hours > 0 }
        return hourly_rate if hourly_rate
      end
    end

    rate_type_name = case days_diff
                     when 2..6 then "День"
                     when 7..29 then "Неделя"
                     when 30..179 then "Месяц"
                     else "Полгода"
                     end

    specific_rate = rates.includes(:rate_type).find { |r| r.rate_type.name == rate_type_name }
    specific_rate || rates.includes(:rate_type).find { |r| r.rate_type.duration_days > 0 } || rates.first
  end

  def availability_calendar
    busy_bookings = bookings.where(status: %w[pending confirmed])
                            .where("end_time > ?", Time.current)
                            .pluck(:start_time, :end_time)

    calendar = {}
    date = Date.tomorrow
    
    365.times do
      month_key = I18n.l(date, format: "%B %Y")
      day_start = date.in_time_zone.change(hour: WORK_START_HOUR)
      day_end = date.in_time_zone.change(hour: WORK_END_HOUR)
      
      day_bookings = busy_bookings.select { |b_start, b_end| b_start < day_end && b_end > day_start }

      status = :available
      tooltip = "Свободно весь день"

      if day_bookings.any?
        occupied_seconds = day_bookings.sum { |b_s, b_e| ([b_e, day_end].min - [b_s, day_start].max).to_f }
        if occupied_seconds >= (day_end - day_start).to_f
          status = :busy
          tooltip = "Занято весь день"
        else
          status = :partial
          clamped = day_bookings.map { |s, e| [[s, day_start].max, [e, day_end].min] }.sort_by { |s, e| s }
          free_windows = []
          current_time = day_start
          clamped.each do |b_start, b_end|
            free_windows << [current_time, b_start] if b_start > current_time
            current_time = [current_time, b_end].max
          end
          free_windows << [current_time, day_end] if current_time < day_end
          tooltip = free_windows.any? ? "Свободно: " + free_windows.map { |s, e| "#{s.strftime('%H:%M')}–#{e.strftime('%H:%M')}" }.join(", ") : "Нет свободных окон"
        end
      end

      calendar[month_key] ||= { month_date: date.beginning_of_month, days: [] }
      calendar[month_key][:days] << { date: date, status: status, tooltip: tooltip }
      date += 1.day
    end
    calendar
  end
end