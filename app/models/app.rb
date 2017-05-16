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
  has_many :environment_variables

  validates :name, presence: true

  before_save :clear_github_branch, if: :github_repo_changed?

  before_save :broadcast_changes

  def image_name
    name.parameterize.underscore
  end

  def network_name
    "#{image_name}_app_network"
  end

  def compose_filename
    buildpack.compose_filename
  end

  def project_name
    "#{image_name}_project"
  end

  def docker_compose_parameters
    {
      'DOTHROKU_IMAGE_NAME':      image_name,
      'DOTHROKU_CONTAINER_NAME':  image_name,
      'DOTHROKU_NETWORK_NAME':    network_name,
      'DOTHROKU_HOSTNAME':        hostname,
      'DOTHROKU_EMAIL':           ssl_email
    }
  end

  private

  def clear_github_branch
    self.github_branch = nil
  end

  def broadcast_changes
    ActionCable.server.broadcast "app_status_channel-#{image_name}", changes
  end
end
