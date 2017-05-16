# == Schema Information
#
# Table name: services
#
#  id   :integer          not null, primary key
#  name :string
#

class Service < ApplicationRecord
  def image_name
    name.parameterize.underscore
  end

  def compose_filename
    "services/#{image_name}/docker-compose.yml"
  end
end
