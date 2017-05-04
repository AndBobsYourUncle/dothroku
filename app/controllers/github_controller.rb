class GithubController < ApplicationController

  def authorize
    address = github.authorize_url redirect_uri: 'http://localhost:3000/callback', scope: 'repo'
    redirect_to address
  end

  def callback
    authorization_code = params[:code]
    access_token = github.get_token authorization_code
    access_token.token

    redirect_to root_url
  end

  private

  def github
    @github ||= Github.new client_id: ENV['GITHUB_CLIENT_ID'], client_secret: ENV['GITHUB_CLIENT_SECRET']
  end
end