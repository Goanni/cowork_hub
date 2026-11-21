class ZonesController < ApplicationController

  def index
    @zones = Zone.includes(:zone_type).order(:name)
  end

  def show
    @zone = Zone.find(params[:id])
    @workspaces = @zone.workspaces.order(:name)
  end
end