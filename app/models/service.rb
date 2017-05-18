# == Schema Information
#
# Table name: services
#
#  id   :integer          not null, primary key
#  name :string
#

class Service < ApplicationRecord
  has_many :service_variables

  accepts_nested_attributes_for :service_variables

  def image_name
    name.parameterize.underscore
  end

  def compose_filename
    "services/#{image_name}/docker-compose.yml"
  end
end
