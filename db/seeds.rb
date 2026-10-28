# Запуск: rails db:seed

require "faker"

puts "=== СОЗДАНИЕ СПРАВОЧНИКОВ ==="

# Роли
member_role = Role.find_or_create_by!(name: "member") { |r| r.description = "Резидент коворкинга" }
admin_role  = Role.find_or_create_by!(name: "admin")  { |r| r.description = "Администратор коворкинга" }
puts "  Роли: #{Role.count}"

# Типы зон
ZoneType.find_or_create_by!(name: "Опенспейс")      { |z| z.description = "Открытое пространство" }
ZoneType.find_or_create_by!(name: "Тихая зона")     { |z| z.description = "Тихая зона" }
ZoneType.find_or_create_by!(name: "Переговорная")   { |z| z.description = "Переговорная комната" }
ZoneType.find_or_create_by!(name: "Конференц-зал")  { |z| z.description = "Конференц-зал" }
puts "  Типы зон: #{ZoneType.count}"

# Удобства
["Wi-Fi", "Розетки", "Настольные лампы", "Кондиционер", "Кулер с водой", "Микроволновка"].each do |name|
  Amenity.find_or_create_by!(name: name)
end
puts "  Удобства: #{Amenity.count}"

# Оборудование
["Проектор", "Флипчарт", "Микрофон", "Колонки", "Принтер", "Веб-камера", "Монитор"].each do |name|
  Equipment.find_or_create_by!(name: name)
end
puts "  Оборудование: #{Equipment.count}"

# Типы тарифов
RateType.find_or_create_by!(name: "Час")     { |r| r.duration_hours = 1; r.duration_days = 0 }
RateType.find_or_create_by!(name: "День")    { |r| r.duration_hours = 0; r.duration_days = 1 }
RateType.find_or_create_by!(name: "Неделя")  { |r| r.duration_hours = 0; r.duration_days = 7 }
RateType.find_or_create_by!(name: "Месяц")   { |r| r.duration_hours = 0; r.duration_days = 30 }
RateType.find_or_create_by!(name: "Полгода") { |r| r.duration_hours = 0; r.duration_days = 180 }
puts "  Типы тарифов: #{RateType.count}"

puts "=== СОЗДАНИЕ ЗОН ==="

Zone.find_or_create_by!(name: "Опенспейс A") do |z|
  z.zone_type = ZoneType.find_by(name: "Опенспейс")
  z.description = "Открытая рабочая зона на 20 столов. Панорамные окна, регулируемые столы и кресла."
  z.capacity = 20
end

Zone.find_or_create_by!(name: "Тихая зона 1") do |z|
  z.zone_type = ZoneType.find_by(name: "Тихая зона")
  z.description = "Зона для работы в тишине. 10 столов с перегородками. Разговоры и звонки запрещены."
  z.capacity = 10
end

Zone.find_or_create_by!(name: "Переговорная 1") do |z|
  z.zone_type = ZoneType.find_by(name: "Переговорная")
  z.description = "Комната для встреч на 6 человек. Стол и кресла."
  z.capacity = 6
end

Zone.find_or_create_by!(name: "Конференц-зал A") do |z|
  z.zone_type = ZoneType.find_by(name: "Конференц-зал")
  z.description = "Зал для презентаций и конференций на 30 человек. Гибкая рассадка."
  z.capacity = 30
end
puts "  Зоны: #{Zone.count}"

puts "=== СОЗДАНИЕ РАБОЧИХ МЕСТ ==="

open_space      = Zone.find_by(name: "Опенспейс A")
quiet_zone      = Zone.find_by(name: "Тихая зона 1")
meeting_room_z  = Zone.find_by(name: "Переговорная 1")
conf_hall_z     = Zone.find_by(name: "Конференц-зал A")

# 20 столов в опенспейсе
(1..20).each do |i|
  Workspace.find_or_create_by!(zone: open_space, name: "Стол #{i}") do |w|
    w.type = "desk"
    w.capacity = 1
    w.description = "Стол в открытой зоне"
  end
end

# 10 столов в тихой зоне
(1..10).each do |i|
  Workspace.find_or_create_by!(zone: quiet_zone, name: "Стол #{i}") do |w|
    w.type = "desk"
    w.capacity = 1
    w.description = "Стол в тихой зоне"
  end
end

# Переговорная
Workspace.find_or_create_by!(zone: meeting_room_z, name: "Переговорная 1") do |w|
  w.type = "meeting_room"
  w.capacity = 6
  w.description = "Комната для встреч"
end

# Конференц-зал
Workspace.find_or_create_by!(zone: conf_hall_z, name: "Конференц-зал A") do |w|
  w.type = "conference_room"
  w.capacity = 30
  w.description = "Большой зал для мероприятий"
end
puts "  Рабочие места: #{Workspace.count}"

puts "=== СОЗДАНИЕ ЦЕН ==="

rate_types = RateType.all.index_by(&:name)

desk_prices = {
  "Час" => 150, "День" => 800, "Неделя" => 4500, "Месяц" => 15000, "Полгода" => 80000
}
quiet_prices = {
  "Час" => 200, "День" => 1000, "Неделя" => 5500, "Месяц" => 18000, "Полгода" => 95000
}
meeting_prices = {
  "Час" => 500, "День" => 4000, "Неделя" => 22000, "Месяц" => 75000, "Полгода" => 400000
}
conf_prices = {
  "Час" => 1500, "День" => 10000, "Неделя" => 55000, "Месяц" => 180000, "Полгода" => 900000
}

open_space.workspaces.each do |ws|
  desk_prices.each { |name, price| Rate.find_or_create_by!(workspace: ws, rate_type: rate_types[name]) { |r| r.price = price } }
end

quiet_zone.workspaces.each do |ws|
  quiet_prices.each { |name, price| Rate.find_or_create_by!(workspace: ws, rate_type: rate_types[name]) { |r| r.price = price } }
end

meeting_ws = Workspace.find_by(type: "meeting_room")
meeting_prices.each { |name, price| Rate.find_or_create_by!(workspace: meeting_ws, rate_type: rate_types[name]) { |r| r.price = price } }

conf_ws = Workspace.find_by(type: "conference_room")
conf_prices.each { |name, price| Rate.find_or_create_by!(workspace: conf_ws, rate_type: rate_types[name]) { |r| r.price = price } }

puts "  Цены (rates): #{Rate.count}"

puts "=== СВЯЗЬ МЕСТ С УДОБСТВАМИ ==="

amenities = Amenity.all.index_by(&:name)
all_amenities = ["Wi-Fi", "Розетки", "Настольные лампы", "Кондиционер", "Кулер с водой", "Микроволновка"]
conf_amenities = ["Wi-Fi", "Розетки", "Настольные лампы", "Кондиционер", "Кулер с водой"]

Workspace.where(type: "desk").each do |ws|
  all_amenities.each { |name| WorkspaceAmenity.find_or_create_by!(workspace: ws, amenity: amenities[name]) }
end

WorkspaceAmenity.where(workspace: meeting_ws).delete_all
all_amenities.each { |name| WorkspaceAmenity.find_or_create_by!(workspace: meeting_ws, amenity: amenities[name]) }

WorkspaceAmenity.where(workspace: conf_ws).delete_all
conf_amenities.each { |name| WorkspaceAmenity.find_or_create_by!(workspace: conf_ws, amenity: amenities[name]) }

puts "  Связи с удобствами: #{WorkspaceAmenity.count}"

puts "=== СВЯЗЬ МЕСТ С ОБОРУДОВАНИЕМ ==="

equipment = Equipment.all.index_by(&:name)

WorkspaceEquipment.where(workspace: meeting_ws).delete_all
["Проектор", "Флипчарт", "Веб-камера"].each { |name| WorkspaceEquipment.find_or_create_by!(workspace: meeting_ws, equipment: equipment[name]) }

WorkspaceEquipment.where(workspace: conf_ws).delete_all
["Проектор", "Флипчарт", "Микрофон", "Колонки", "Веб-камера"].each { |name| WorkspaceEquipment.find_or_create_by!(workspace: conf_ws, equipment: equipment[name]) }

puts "  Связи с оборудованием: #{WorkspaceEquipment.count}"

puts "=== СОЗДАНИЕ ПОЛЬЗОВАТЕЛЕЙ ==="

# Админ
User.find_or_create_by!(email: "admin@cowork.local") do |u|
  u.password = "admin12345"
  u.password_confirmation = "admin12345"
  u.first_name = "Анна"
  u.last_name = "Гончарова"
  u.phone = "+79000000000"
  u.role = admin_role
end

# Member
User.find_or_create_by!(email: "member@cowork.local") do |u|
  u.password = "member12345"
  u.password_confirmation = "member12345"
  u.first_name = "Иван"
  u.last_name = "Иванов"
  u.phone = "+79000000001"
  u.role = member_role
end

# Ещё 98 member — всего 100
existing_members = User.where(role: member_role).count
members_to_create = [100 - existing_members, 0].max

members_to_create.times do |i|
  User.create!(
    email: "member#{existing_members + i + 1}@cowork.local",
    password: "password123",
    password_confirmation: "password123",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: Faker::PhoneNumber.cell_phone,
    role: member_role
  )
end

puts "  Пользователей: #{User.count} (member: #{User.where(role: member_role).count}, admin: #{User.where(role: admin_role).count})"

puts "=== ГЕНЕРАЦИЯ ОПЕРАТИВНЫХ ДАННЫХ ==="

if Booking.count < 1000
  puts "  Очистка старых оперативных данных..."
  [Notification, BookingStatusHistory, Invoice, Booking].each(&:delete_all)

  members = User.where(role: member_role).to_a
  workspaces = Workspace.all.to_a
  all_rate_types = RateType.all.to_a
  statuses = %w[pending confirmed cancelled completed]

  members.each do |user|
    100.times do
      workspace = workspaces.sample
      rate_type = all_rate_types.sample
      rate = Rate.find_by(workspace: workspace, rate_type: rate_type)
      next if rate.nil?

      days_ago = rand(0..180)
      start_time = (Time.current - days_ago.days).beginning_of_hour + rand(0..12).hours
      end_time = start_time + rate_type.duration_hours.hours + rate_type.duration_days.days
      status = statuses.sample

      booking = Booking.create!(
        user: user,
        workspace: workspace,
        start_time: start_time,
        end_time: end_time,
        total_price: rate.price,
        status: status
      )

      BookingStatusHistory.create!(booking: booking, status: "pending", changed_at: booking.created_at)
      if status != "pending"
        BookingStatusHistory.create!(booking: booking, status: status, changed_at: booking.created_at + rand(1..24).hours)
      end

      if %w[confirmed completed].include?(status)
        invoice_status = status == "completed" ? "paid" : "pending"
        Invoice.create!(
          booking: booking,
          user: user,
          amount: rate.price,
          status: invoice_status,
          issued_at: booking.created_at,
          paid_at: invoice_status == "paid" ? booking.created_at + rand(1..48).hours : nil
        )
      end

      Notification.create!(
        user: user,
        booking: booking,
        message: "Бронь ##{booking.id} создана на #{workspace.name}",
        read: [true, false].sample
      )
    end
  end
else
  puts "  Оперативные данные уже есть (#{Booking.count} броней) — пропускаем генерацию."
end

puts "=== ГОТОВО ==="
puts "  Bookings: #{Booking.count}"
puts "  Invoices: #{Invoice.count}"
puts "  BookingStatusHistory: #{BookingStatusHistory.count}"
puts "  Notifications: #{Notification.count}"