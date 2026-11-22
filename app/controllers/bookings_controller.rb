class BookingsController < ApplicationController
  before_action :require_login

  def index
    @bookings = current_user.bookings.includes(:workspace).order(start_time: :desc)
  end

  def show
    @booking = current_user.bookings.find(params[:id])
    @history = @booking.booking_status_histories.order(:changed_at)
  end

  def new
    @workspace = Workspace.find(params[:workspace_id])
    
    if params[:date].present?
      selected_date = Date.parse(params[:date])
      @booking = Booking.new(
        workspace: @workspace,
        start_time: selected_date.in_time_zone.change(hour: Workspace::WORK_START_HOUR),
        end_time: selected_date.in_time_zone.change(hour: Workspace::WORK_START_HOUR + 1)
      )
    else
      @booking = Booking.new(workspace: @workspace)
    end

    @calendar = @workspace.availability_calendar
  end

  def create
    @workspace = Workspace.find(params[:workspace_id])
    @booking = current_user.bookings.new(booking_params.merge(workspace: @workspace))
    @calendar = @workspace.availability_calendar

    rate = @workspace.find_best_rate(@booking.start_time, @booking.end_time)
    
    if rate && @booking.start_time && @booking.end_time
      days_diff = (@booking.end_time.to_date - @booking.start_time.to_date).to_i + 1
      work_hours = Workspace::WORK_END_HOUR - Workspace::WORK_START_HOUR
      booking_hours = (@booking.end_time - @booking.start_time) / 1.hour

      if days_diff == 1 && booking_hours < work_hours
        units = (booking_hours / rate.rate_type.duration_hours).ceil
      else
        units = (days_diff.to_f / (rate.rate_type.duration_days > 0 ? rate.rate_type.duration_days : 1)).ceil
      end
      
      units = 1 if units < 1
      @booking.total_price = rate.price * units
    end

    unless @booking.valid?
      return render :new, status: :unprocessable_entity
    end

    if @workspace.bookings.where(status: %w[pending confirmed])
                    .where("start_time < ? AND end_time > ?", @booking.end_time, @booking.start_time)
                    .exists?
      flash.now[:alert] = "Место уже занято на это время"
      return render :new, status: :unprocessable_entity
    end

    begin
      ActiveRecord::Base.transaction(isolation: :serializable) do
        @booking.save!
        BookingStatusHistory.create!(booking: @booking, status: @booking.status, changed_at: Time.current)
        Invoice.create!(booking: @booking, user: current_user, amount: @booking.total_price, status: "pending", issued_at: Time.current)
      end
      redirect_to bookings_path, notice: "Бронь создана"
      
    rescue ActiveRecord::SerializationFailure
      flash.now[:alert] = "Конфликт бронирования. Попробуйте ещё раз."
      render :new, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.message
      render :new, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_time, :end_time)
  end
end