class DockerApi::ContainersController < ApplicationController
  def stop
    load_container

    @container.stop

    redirect_to :back
  end

  def start
    load_container

    @container.start

    redirect_to :back
  end

  private

  def load_container
    @container = DockerApi::Container.find(params[:id])
  end
end
