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

  after_create :add_environment_variables

  def image_name
    "#{service.image_name}_#{app.image_name}"
  end

  def network_name
    app.network_name
  end

  def project_name
    "#{image_name}_project"
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

  private

  def add_environment_variables
    service.service_variables.each do |service_variable|
      env_var = service_variable.environment_variable self

      app.environment_variables.build(
        name:   env_var.name,
        value:  env_var.value
      ).save!
    end
  end

end
