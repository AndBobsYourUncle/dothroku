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
end
