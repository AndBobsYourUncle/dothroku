class DockerApi::ContainersController < ApplicationController
  before_action :authenticate_user!

  def stop
    load_container

    @container.stop

    redirect_back fallback_location: root_path
  end

  def start
    load_container

    @container.start

    redirect_back fallback_location: root_path
  end

  private

  def load_container
    @container = DockerApi::Container.find(params[:id])
  end
end
