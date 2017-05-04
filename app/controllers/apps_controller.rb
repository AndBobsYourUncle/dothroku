class AppsController < ApplicationController

  def authorize
    load_app

    session[:github_app_id] = @app.id

    address = github.authorize_url redirect_uri: 'http://localhost:3000/callback', scope: 'repo'
    redirect_to address
  end

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

  def update
    load_app

    if @app.update app_params
      redirect_to app_path(@app), flash: {success: "App has been successfully updated!"}
    else
      render :new
    end
  end

  private

  def github
    @github ||= Github.new client_id: ENV['GITHUB_CLIENT_ID'], client_secret: ENV['GITHUB_CLIENT_SECRET']
  end

  def load_app
    @app = App.find(params[:id])
  end

  def app_params
    params.require(:app).permit :name, :github_auth_token
  end

end
