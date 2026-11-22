class WorkspacesController < ApplicationController
  # Просмотр открыт всем

  def index
    @zone = Zone.find(params[:zone_id])
    @workspaces = @zone.workspaces.order(:name)
  end

  def show
    @workspace = Workspace.includes(:zone, :amenities, :equipment, rates: :rate_type)
                          .find(params[:id])
    @calendar = @workspace.availability_calendar # Вызываем наш новый метод
  end
end