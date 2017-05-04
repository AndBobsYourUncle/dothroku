class AppsController < ApplicationController

  def new
    @app = App.new
  end

  def create
    @app = App.new app_params

    if @app.save
      redirect_to app_path(@app), flash: {success: "App has been successfully created!"}
    else
      render :new
    end
  end

  def destroy
    load_app

    @app.destroy

    redirect_to root_path, flash: {success: "App has been successfully deleted!"}
  end

  def show
    load_app
  end

  private

  def load_app
    @app = App.find(params[:id])
  end

  def app_params
    params.require(:app).permit :name
  end

end
