# == Schema Information
#
# Table name: apps
#
#  buildpack_id      :integer
#  created_at        :datetime         not null
#  deploying         :boolean
#  github_auth_token :string
#  github_branch     :string
#  github_repo       :string
#  hostname          :string
#  id                :integer          not null, primary key
#  name              :string
#  ssl_email         :string
#  updated_at        :datetime         not null
#

class App < ApplicationRecord
  belongs_to :buildpack, optional: true

  has_many :app_services

  validates :name, presence: true

  before_save :clear_github_branch, if: :github_repo_changed?

  before_save :broadcast_changes

  def image_name
    name.parameterize
  end

  def network_name
    "#{name.parameterize}_app_network"
  end

  private

  def clear_github_branch
    self.github_branch = nil
  end

  def broadcast_changes
    ActionCable.server.broadcast "app_status_channel-#{image_name}", changes
  end
end
