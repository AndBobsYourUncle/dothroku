# == Schema Information
#
# Table name: environment_variables
#
#  app_id :integer
#  id     :integer          not null, primary key
#  name   :string
#  value  :string
#

class EnvironmentVariable < ApplicationRecord
  belongs_to :app
end
