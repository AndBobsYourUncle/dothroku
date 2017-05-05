class GithubController < ApplicationController

  def callback
    authorization_code = params[:code]
    access_token = github.get_token authorization_code
    session[:github_token] = access_token.token

    App.find(session[:github_app_id]).update(github_auth_token: access_token.token)

    redirect_to edit_app_path(session[:github_app_id])
  end

  private

  def github
    @github ||= Github.new client_id: ENV['GITHUB_CLIENT_ID'], client_secret: ENV['GITHUB_CLIENT_SECRET']
  end
end