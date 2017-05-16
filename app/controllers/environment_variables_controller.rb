class EnvironmentVariablesController < ApplicationController

  def index
    load_app
    load_services
  end

  def new
    load_app
    @environment_variable = EnvironmentVariable.new(app: @app)
  end

  def create
    load_app

    @environment_variable = EnvironmentVariable.new environment_variable_params

    if @environment_variable.save
      redirect_to environment_variables_path(@app), flash: {success: "Service been successfully added!"}
    else
      render :new
    end
  end

  def destroy

    load_environment_variable
    @app = @environment_variable.app

    @environment_variable.destroy

    redirect_to environment_variables_path(@app), flash: {success: "Service been successfully removed!"}
  end

  private

  def load_app
    @app = App.find(params[:id])
  end

  def load_services
    @environment_variables = @app.environment_variables
  end

  def load_environment_variable
    @environment_variable = EnvironmentVariable.find(params[:id])
  end

  def environment_variable_params
    params.require(:environment_variable).permit :app_id, :name, :value
  end

end
