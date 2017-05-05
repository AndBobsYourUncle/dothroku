# == Schema Information
#
# Table name: apps
#
#  id                :integer          not null, primary key
#  name              :string
#  github_auth_token :string
#  github_repo       :string
#  github_branch     :string
#  created_at        :datetime         not null
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
