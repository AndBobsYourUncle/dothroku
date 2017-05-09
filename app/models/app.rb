# == Schema Information
#
# Table name: apps
#
#  created_at        :datetime         not null
#  deploying         :boolean
#  github_auth_token :string
#  github_branch     :string
#  github_repo       :string
#  id                :integer          not null, primary key
#  name              :string
#  updated_at        :datetime         not null
#

class App < ApplicationRecord
  validates :name, presence: true

  before_save :clear_github_branch, if: :github_repo_changed?

  private

  def clear_github_branch
    self.github_branch = nil
  end
end
