class PagesController < ApplicationController
  def home
    @apps = App.all
  end
end
