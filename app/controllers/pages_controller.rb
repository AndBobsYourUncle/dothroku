class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:secret]

  def home

  end

  def secret
    @containers = DockerAPI::Container.all()
  end
end
