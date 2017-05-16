# == Schema Information
#
# Table name: app_services
#
#  app_id     :integer
#  id         :integer          not null, primary key
#  service_id :integer
#

class AppService < ApplicationRecord
  belongs_to :app
  belongs_to :service

  accepts_nested_attributes_for :service

  def image_name
    "#{service.image_name}_#{app.image_name}"
  end

  def network_name
    app.network_name
  end

  def docker_compose_parameters
    {
      'DOTHROKU_CONTAINER_NAME':  image_name,
      'DOTHROKU_NETWORK_NAME':    network_name
    }
  end

  def compose_filename
    service.compose_filename
  end

end
