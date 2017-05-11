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

  validates :name, presence: true

  before_save :clear_github_branch, if: :github_repo_changed?

  def image_name
    name.parameterize
  end

  private

  def clear_github_branch
    self.github_branch = nil
  end
end
