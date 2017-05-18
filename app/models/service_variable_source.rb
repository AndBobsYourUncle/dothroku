# == Schema Information
#
# Table name: service_variable_sources
#
#  id                  :integer          not null, primary key
#  name                :string
#  service_variable_id :integer
#  source_attribute    :string
#  source_model        :string
#

class ServiceVariableSource < ApplicationRecord
  belongs_to :service_variable, optional: true
  has_one :service, through: :service_variable

  attr_accessor :app_service

  def get_value app_service
    self.app_service = app_service

    source = self.public_send source_model

    source.public_send source_attribute
  end
end
