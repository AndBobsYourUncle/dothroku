class AppServicesController < ApplicationController

  def index
    load_app
    load_services
  end

  def new
    load_app
    @app_service = AppService.new(app: @app)
  end

  def create
    load_app

    @app_service = AppService.new app_service_params

    if @app_service.save
      redirect_to app_services_path(@app), flash: {success: "Service been successfully added!"}
    else
      render :new
    end
  end

  def destroy

    load_app_service
    @app = @app_service.app

    @app_service.destroy

    redirect_to app_services_path(@app), flash: {success: "Service been successfully removed!"}
  end

  private

  def load_app
    @app = App.find(params[:id])
  end

  def load_services
    @app_services = @app.app_services
  end

  def load_app_service
    @app_service = AppService.find(params[:id])
  end

  def app_service_params
    params.require(:app_service).permit :app_id, :service_id
  end

end
