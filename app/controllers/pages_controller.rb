class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:secret]

  def home
    @apps = App.all
  end

  def secret
    @containers = DockerApi::Container.all()
  end
end
