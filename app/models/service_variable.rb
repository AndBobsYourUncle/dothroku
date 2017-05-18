# == Schema Information
#
# Table name: service_variables
#
#  build_type :string
#  id         :integer          not null, primary key
#  name       :string
#  service_id :integer
#  value      :string
#

class ServiceVariable < ApplicationRecord
  extend Enumerize

  belongs_to :service, optional: true

  has_many :service_variable_sources

  enumerize :build_type, in: [:text, :interpolate]

  accepts_nested_attributes_for :service_variable_sources

  attr_accessor :app_service

  def environment_variable app_service
    self.app_service = app_service

    env_value = case build_type.to_sym
    when :text
      value
    when :interpolate
      interpolate_value
    end

    EnvironmentVariable.new name: name, value: env_value
  end

  private

  def interpolate_value
    values = service_variable_sources.collect do |source|
      [source.name.to_sym, source.get_value(app_service)]
    end.to_h

    sprintf value, values
  end
end
