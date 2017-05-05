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

require 'test_helper'

class AppTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
